// Nightly POS → HR inventory sync.
//
// Reads one business day of completed POS orders, explodes them through
// the per-product recipes, and posts the consumption into the Hassad HR
// app's existing inventory as `sale` movements (one per ingredient per
// branch per day), decrementing stock. Also refreshes the POS `hr_items`
// mirror so the recipe editor's ingredient picker stays current.
//
// Idempotent: each movement carries a `POS-SYNC <date>` notes tag and is
// skipped if already present, so re-runs never double-deduct.
//
// Env:
//   POS_DB_URL  – session-pooler URI of the POS Supabase project
//   HR_DB_URL   – session-pooler URI of the HR Supabase project
//   SYNC_DATE   – optional YYYY-MM-DD override; default = yesterday in KSA
//
// Unmatched anything (product without recipe, ingredient name or branch
// not found in HR inventory) is REPORTED, never silently dropped.

import pg from 'pg';

const { Client } = pg;

function ksaYesterday() {
  const now = new Date(Date.now() + 3 * 3600 * 1000); // KSA = UTC+3
  now.setUTCDate(now.getUTCDate() - 1);
  return now.toISOString().slice(0, 10);
}

const DATE = (process.env.SYNC_DATE || '').trim() || ksaYesterday();
if (!/^\d{4}-\d{2}-\d{2}$/.test(DATE)) { console.error(`::error::SYNC_DATE "${DATE}" is not YYYY-MM-DD`); process.exit(1); }
const TAG = `POS-SYNC ${DATE}`;

for (const v of ['POS_DB_URL', 'HR_DB_URL']) {
  if (!process.env[v]) { console.error(`::error::${v} is not set`); process.exit(1); }
}

const report = { movements: 0, skipped: 0, noRecipe: new Map(), noHrItem: new Set(), zeroDay: false };

const pos = new Client({ connectionString: process.env.POS_DB_URL, ssl: { rejectUnauthorized: false } });
const hr  = new Client({ connectionString: process.env.HR_DB_URL,  ssl: { rejectUnauthorized: false } });
await pos.connect(); await hr.connect();

try {
  // ---- 1. Pull the POS day ----
  const branches = (await pos.query('SELECT id, name, hr_branch FROM public.branches')).rows;
  const hrBranchOf = new Map(branches.map(b => [b.id, (b.hr_branch || b.name || '').trim()]));

  const sold = (await pos.query(
    `SELECT o.branch_id, oi.item_id, oi.name_en, SUM(oi.qty) AS qty
       FROM public.orders o
       JOIN public.order_items oi ON oi.order_id = o.id
      WHERE o.business_date = $1 AND o.status = 'completed'
      GROUP BY o.branch_id, oi.item_id, oi.name_en`, [DATE])).rows;

  const recipes = (await pos.query('SELECT item_id, hr_item_name, qty, unit FROM public.recipes')).rows;
  const recipesByItem = new Map();
  for (const r of recipes) {
    if (!recipesByItem.has(r.item_id)) recipesByItem.set(r.item_id, []);
    recipesByItem.get(r.item_id).push(r);
  }

  if (!sold.length) { report.zeroDay = true; console.log(`No completed orders for ${DATE}.`); }

  // consumption: hrBranch -> ingredientNameLower -> { name, qty }
  const consumption = new Map();
  for (const line of sold) {
    const recipe = line.item_id ? recipesByItem.get(line.item_id) : null;
    if (!recipe || !recipe.length) {
      const prev = report.noRecipe.get(line.name_en) || 0;
      report.noRecipe.set(line.name_en, prev + Number(line.qty));
      continue;
    }
    const branch = hrBranchOf.get(line.branch_id) || '';
    if (!consumption.has(branch)) consumption.set(branch, new Map());
    const byIng = consumption.get(branch);
    for (const ing of recipe) {
      const key = ing.hr_item_name.toLowerCase();
      const cur = byIng.get(key) || { name: ing.hr_item_name, qty: 0 };
      cur.qty += Number(line.qty) * Number(ing.qty);
      byIng.set(key, cur);
    }
  }

  // ---- 2. Post into HR inventory ----
  const hrItems = (await hr.query('SELECT id, name, branch, unit, quantity FROM public.inventory_items')).rows;
  const findHrItem = (name, branch) => {
    const nameMatches = hrItems.filter(i => i.name.trim().toLowerCase() === name.toLowerCase());
    if (!nameMatches.length) return null;
    const branchMatch = nameMatches.filter(i => (i.branch || '').trim().toLowerCase() === branch.toLowerCase());
    if (branchMatch.length === 1) return branchMatch[0];
    if (nameMatches.length === 1) return nameMatches[0]; // single brand-wide row
    return null; // ambiguous: multiple branch rows, none matching this branch
  };

  await hr.query('BEGIN');
  for (const [branch, byIng] of consumption) {
    for (const { name, qty } of byIng.values()) {
      const item = findHrItem(name, branch);
      if (!item) { report.noHrItem.add(`${name} @ ${branch || '(no branch)'}`); continue; }
      const dup = await hr.query(
        `SELECT 1 FROM public.inventory_movements
          WHERE item_id = $1 AND type = 'sale' AND occurred_at = $2 AND notes = $3 LIMIT 1`,
        [item.id, DATE, TAG]);
      if (dup.rows.length) { report.skipped++; continue; }
      const rounded = Math.round(qty * 100) / 100;
      await hr.query(
        `INSERT INTO public.inventory_movements (item_id, qty_delta, type, branch, occurred_at, notes)
         VALUES ($1, $2, 'sale', $3, $4, $5)`,
        [item.id, -rounded, item.branch || branch || null, DATE, TAG]);
      await hr.query(
        'UPDATE public.inventory_items SET quantity = quantity - $1, updated_at = now() WHERE id = $2',
        [rounded, item.id]);
      report.movements++;
    }
  }
  await hr.query('COMMIT');

  // ---- 3. Refresh the POS hr_items mirror ----
  const distinct = new Map();
  for (const i of hrItems) {
    const key = i.name.trim().toLowerCase();
    if (!distinct.has(key)) distinct.set(key, { name: i.name.trim(), unit: i.unit || 'units' });
  }
  await pos.query('BEGIN');
  await pos.query('DELETE FROM public.hr_items');
  for (const { name, unit } of distinct.values()) {
    await pos.query(
      'INSERT INTO public.hr_items (name, unit) VALUES ($1, $2) ON CONFLICT (name) DO UPDATE SET unit = $2, updated_at = now()',
      [name, unit]);
  }
  await pos.query('COMMIT');

  // ---- 4. Report ----
  const lines = [];
  lines.push(`# Inventory sync — ${DATE}`);
  lines.push(`- Movements posted: **${report.movements}** (skipped as already-synced: ${report.skipped})`);
  lines.push(`- HR ingredient names mirrored to POS: **${distinct.size}**`);
  if (report.zeroDay) lines.push(`- ⚠️ No completed orders found for ${DATE}.`);
  if (report.noRecipe.size) {
    lines.push(`\n## Products sold WITHOUT a recipe (no inventory deducted)`);
    for (const [name, qty] of [...report.noRecipe.entries()].sort((a, b) => b[1] - a[1]))
      lines.push(`- ${name} — ${qty} sold`);
  }
  if (report.noHrItem.size) {
    lines.push(`\n## Recipe ingredients NOT found in HR inventory (fix the name or branch)`);
    for (const s of report.noHrItem) lines.push(`- ${s}`);
  }
  const summary = lines.join('\n');
  console.log(summary);
  if (process.env.GITHUB_STEP_SUMMARY) {
    const { appendFileSync } = await import('node:fs');
    appendFileSync(process.env.GITHUB_STEP_SUMMARY, summary + '\n');
  }
} catch (e) {
  try { await hr.query('ROLLBACK'); } catch {}
  try { await pos.query('ROLLBACK'); } catch {}
  console.error('::error::' + (e?.message || e));
  process.exitCode = 1;
} finally {
  await pos.end(); await hr.end();
}
