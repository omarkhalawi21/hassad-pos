// Supabase Edge Function: order-intake
//
// The ONLY way a customer order reaches the database. order.html is a public,
// anonymous page: it has no session and no RLS grant on any table. Everything
// it needs comes through here, under the service role.
//
// The rule this function exists to enforce: the client is never trusted with a
// price. It sends item ids, quantities and modifier option ids; every riyal is
// looked up here and recomputed. A browser can ask for a 0.00 SAR latte all it
// likes -- it will be priced from menu_items like everyone else's.
//
// No secrets beyond the injected SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY.
// Deploy with --no-verify-jwt: callers are anonymous by design.
//
// Actions (POST { action, ... }):
//   menu   -> branches (with open/closed now) + the Online menu for one branch
//   place  -> validate, re-price, insert a `pending` online order; returns token
//   track  -> order status by public_token (no login, unguessable id)

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, "Content-Type": "application/json" } });
const fail = (message: string, status = 400) => json({ ok: false, error: message }, status);

const admin = () =>
  createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { persistSession: false },
  });

const MAX_QTY_PER_LINE = 20;
const MAX_LINES = 40;
const MAX_PENDING_PER_PHONE = 3;

// KSA mobile, stored the way the rest of the POS stores it (05xxxxxxxx).
// Accepts +9665..., 9665..., 5... and normalises them all.
function normalisePhone(raw: string): string | null {
  const d = String(raw || "").replace(/[^0-9]/g, "");
  let n = d;
  if (n.startsWith("00966")) n = n.slice(5);
  else if (n.startsWith("966")) n = n.slice(3);
  if (n.startsWith("5") && n.length === 9) n = "0" + n;
  return /^05[0-9]{8}$/.test(n) ? n : null;
}

// VAT is inclusive in this menu, so the tax is the portion already inside the
// price. Mirrors vatPortion() in index.html exactly -- if one changes, both do.
const vatPortion = (totalInc: number, rate: number) => totalInc * rate / (100 + rate);
const money = (n: number) => Math.round(n * 100) / 100;

async function loadSettings(db: ReturnType<typeof admin>) {
  const { data } = await db.from("pos_settings").select("*").limit(1).single();
  return data;
}

// ---- menu: what this branch can sell online, right now ----------------------
async function doMenu(db: ReturnType<typeof admin>, branchId: string | null) {
  const settings = await loadSettings(db);
  if (!settings?.online_ordering_enabled) return json({ ok: true, enabled: false, branches: [] });

  const { data: branches } = await db
    .from("branches").select("id, name, name_ar, phone")
    .eq("active", true).eq("accepts_online", true).order("name");

  // branch_is_open() does the Asia/Riyadh conversion in the DB so the answer
  // never depends on where this function happens to run.
  const withOpen = [];
  for (const b of branches ?? []) {
    const { data: open } = await db.rpc("branch_is_open", { p_branch: b.id });
    const { data: hours } = await db
      .from("branch_hours").select("dow, open_time, close_time, closed").eq("branch_id", b.id).order("dow");
    withOpen.push({ ...b, open: !!open, hours: hours ?? [] });
  }
  if (!branchId) return json({ ok: true, enabled: true, branches: withOpen, prepMinutes: settings.online_prep_minutes });

  const branch = withOpen.find((b) => b.id === branchId);
  if (!branch) return fail("That branch is not taking online orders.", 404);

  // The Online group is the allowlist. No group membership = nothing sells,
  // which is the safe default (staff items stay invisible).
  const { data: grp } = await db.from("menu_groups").select("id").eq("name", "Online").maybeSingle();
  if (!grp) return json({ ok: true, enabled: true, branch, categories: [], items: [] });

  const { data: inGroup } = await db.from("item_menu_groups").select("item_id").eq("group_id", grp.id);
  const allowed = (inGroup ?? []).map((r: any) => r.item_id);
  if (!allowed.length) return json({ ok: true, enabled: true, branch, categories: [], items: [] });

  const { data: offHere } = await db.from("menu_item_branch_off").select("item_id").eq("branch_id", branch.id);
  const off = new Set((offHere ?? []).map((r: any) => r.item_id));
  const sellable = allowed.filter((id: string) => !off.has(id));
  if (!sellable.length) return json({ ok: true, enabled: true, branch, categories: [], items: [] });

  const { data: items } = await db
    .from("menu_items").select("id, category_id, name_en, name_ar, price, photo, sort_order")
    .in("id", sellable).eq("active", true).order("sort_order");
  const catIds = [...new Set((items ?? []).map((i: any) => i.category_id))];
  const { data: cats } = await db
    .from("menu_categories").select("id, name_en, name_ar, sort_order")
    .in("id", catIds).eq("active", true).order("sort_order");

  // Modifier groups, with the per-item min/max the picker needs.
  const itemIds = (items ?? []).map((i: any) => i.id);
  const { data: assigns } = await db
    .from("item_modifier_groups").select("item_id, group_id, min_select, max_select, default_option_id")
    .in("item_id", itemIds);
  const groupIds = [...new Set((assigns ?? []).map((a: any) => a.group_id))];
  const { data: groups } = groupIds.length
    ? await db.from("modifier_groups").select("id, name_en, name_ar, sort_order").in("id", groupIds).eq("active", true)
    : { data: [] as any[] };
  const { data: options } = groupIds.length
    ? await db.from("modifier_options").select("id, group_id, name_en, name_ar, price_delta, sort_order")
        .in("group_id", groupIds).eq("active", true).order("sort_order")
    : { data: [] as any[] };

  return json({
    ok: true, enabled: true, branch,
    prepMinutes: settings.online_prep_minutes,
    minOrder: Number(settings.online_min_order || 0),
    currency: settings.currency,
    categories: cats ?? [], items: items ?? [],
    modifierAssigns: assigns ?? [], modifierGroups: groups ?? [], modifierOptions: options ?? [],
  });
}

// ---- place: the only write path --------------------------------------------
async function doPlace(db: ReturnType<typeof admin>, body: any) {
  const settings = await loadSettings(db);
  if (!settings?.online_ordering_enabled) return fail("Online ordering is currently closed.", 503);

  const name = String(body?.customer_name || "").trim().slice(0, 80);
  const phone = normalisePhone(body?.customer_phone);
  if (!name) return fail("Please give a name for the order.");
  if (!phone) return fail("Please enter a valid Saudi mobile number (05xxxxxxxx).");

  const { data: branch } = await db
    .from("branches").select("id, name, accepts_online, active").eq("id", body?.branch_id || "").maybeSingle();
  if (!branch || !branch.active || !branch.accepts_online) return fail("That branch is not taking online orders.", 404);

  const { data: open } = await db.rpc("branch_is_open", { p_branch: branch.id });
  if (!open) return fail(`${branch.name} is closed right now.`, 409);

  // One customer cannot flood the queue while the branch is deciding.
  const { count: pending } = await db
    .from("orders").select("id", { count: "exact", head: true })
    .eq("channel", "online").eq("customer_phone", phone).eq("status", "pending");
  if ((pending ?? 0) >= MAX_PENDING_PER_PHONE)
    return fail("You already have orders waiting to be accepted. Please collect those first.", 429);

  const lines = Array.isArray(body?.items) ? body.items : [];
  if (!lines.length) return fail("Your basket is empty.");
  if (lines.length > MAX_LINES) return fail("That is too many different items for one order.");

  // Re-derive the sellable set exactly as doMenu() did. A stale tab must not
  // be able to order something that has since been pulled from the channel.
  const { data: grp } = await db.from("menu_groups").select("id").eq("name", "Online").maybeSingle();
  if (!grp) return fail("Online ordering is not configured yet.", 503);
  const { data: inGroup } = await db.from("item_menu_groups").select("item_id").eq("group_id", grp.id);
  const allowed = new Set((inGroup ?? []).map((r: any) => r.item_id));
  const { data: offHere } = await db.from("menu_item_branch_off").select("item_id").eq("branch_id", branch.id);
  const off = new Set((offHere ?? []).map((r: any) => r.item_id));

  const wantedIds = [...new Set(lines.map((l: any) => String(l?.item_id || "")))];
  const { data: items } = await db
    .from("menu_items").select("id, name_en, name_ar, price, active").in("id", wantedIds);
  const itemById = new Map((items ?? []).map((i: any) => [i.id, i]));

  const { data: assigns } = await db
    .from("item_modifier_groups").select("item_id, group_id, min_select, max_select").in("item_id", wantedIds);
  const groupIds = [...new Set((assigns ?? []).map((a: any) => a.group_id))];
  const { data: options } = groupIds.length
    ? await db.from("modifier_options").select("id, group_id, name_en, name_ar, price_delta, active").in("group_id", groupIds)
    : { data: [] as any[] };
  const optById = new Map((options ?? []).map((o: any) => [o.id, o]));

  const priced: any[] = [];
  for (const line of lines) {
    const item = itemById.get(String(line?.item_id || ""));
    if (!item || !item.active) return fail("One of the items is no longer available. Please refresh the menu.", 409);
    if (!allowed.has(item.id) || off.has(item.id))
      return fail(`"${item.name_en}" is not available at ${branch.name} right now.`, 409);

    const qty = Number(line?.qty);
    if (!Number.isInteger(qty) || qty < 1 || qty > MAX_QTY_PER_LINE)
      return fail(`Choose between 1 and ${MAX_QTY_PER_LINE} of each item.`);

    const chosen: string[] = Array.isArray(line?.modifier_option_ids)
      ? [...new Set(line.modifier_option_ids.map((x: any) => String(x)))] : [];

    // Every chosen option must belong to a group actually assigned to THIS
    // item, and each group's min/max must hold. Both are re-checked here
    // because the picker that enforced them lives in the customer's browser.
    const myGroups = (assigns ?? []).filter((a: any) => a.item_id === item.id);
    const byGroup = new Map<string, number>();
    const snapshot: any[] = [];
    let delta = 0;
    for (const oid of chosen) {
      const opt = optById.get(oid);
      if (!opt || !opt.active) return fail("One of the options is no longer available. Please refresh the menu.", 409);
      const assigned = myGroups.find((a: any) => a.group_id === opt.group_id);
      if (!assigned) return fail(`That option does not belong to "${item.name_en}".`);
      byGroup.set(opt.group_id, (byGroup.get(opt.group_id) ?? 0) + 1);
      delta += Number(opt.price_delta || 0);
      // Same camelCase shape the till writes, so receipts and the bar ticket
      // render an online order identically to a counter one.
      snapshot.push({ id: opt.id, nameEn: opt.name_en, nameAr: opt.name_ar, priceDelta: Number(opt.price_delta || 0) });
    }
    for (const a of myGroups) {
      const n = byGroup.get(a.group_id) ?? 0;
      const min = Number(a.min_select || 0), max = Number(a.max_select || 1);
      if (n < min) return fail(`"${item.name_en}" needs at least ${min} option selected.`);
      if (n > max) return fail(`"${item.name_en}" allows at most ${max} options.`);
    }

    const unit = money(Number(item.price) + delta);
    priced.push({
      item_id: item.id, name_en: item.name_en, name_ar: item.name_ar,
      unit_price: unit, qty, line_total: money(unit * qty),
      modifiers: snapshot.length ? snapshot : null,
    });
  }

  const total = money(priced.reduce((s, l) => s + l.line_total, 0));
  const minOrder = Number(settings.online_min_order || 0);
  if (minOrder > 0 && total < minOrder) return fail(`The minimum online order is ${minOrder.toFixed(2)} ${settings.currency}.`);
  const vat = money(vatPortion(total, Number(settings.vat_rate)));

  const orderRow: any = {
    branch_id: branch.id, status: "pending", channel: "online", order_type: "pickup",
    subtotal: money(total - vat), vat_amount: vat, total,
    customer_name: name, customer_phone: phone,
    note: String(body?.note || "").trim().slice(0, 300) || null,
    pickup_eta_minutes: Number(settings.online_prep_minutes || 15),
  };

  // order_no comes from the same per-branch daily trigger the counter uses, so
  // an online order and a walk-in share one sequence. Concurrent inserts can
  // collide on the unique (branch, date, no) -- retry once, as saveOrder does.
  let order: any = null;
  for (let attempt = 0; attempt < 2 && !order; attempt++) {
    const { data, error } = await db.from("orders").insert(orderRow).select().single();
    if (error) {
      if ((error as any).code === "23505" && attempt === 0) continue;
      return fail("Could not place the order. Please try again.", 500);
    }
    order = data;
  }
  if (!order) return fail("Could not place the order. Please try again.", 500);

  const { error: liErr } = await db.from("order_items").insert(priced.map((l) => ({ ...l, order_id: order.id })));
  if (liErr) {
    // Never leave a priced-at-zero shell in the queue for a barista to accept.
    await db.from("orders").delete().eq("id", order.id);
    return fail("Could not place the order. Please try again.", 500);
  }

  return json({
    ok: true, order_no: order.order_no, token: order.public_token,
    total, eta: orderRow.pickup_eta_minutes, branch: branch.name,
  });
}

// ---- track: the customer's status page -------------------------------------
async function doTrack(db: ReturnType<typeof admin>, token: string) {
  if (!/^[0-9a-f-]{36}$/i.test(token || "")) return fail("Unknown order.", 404);
  const { data: order } = await db
    .from("orders")
    .select("id, order_no, status, total, pickup_eta_minutes, accepted_at, ready_at, reject_reason, created_at, branch_id, customer_name")
    .eq("public_token", token).eq("channel", "online").maybeSingle();
  if (!order) return fail("Unknown order.", 404);

  const { data: branch } = await db.from("branches").select("name, name_ar, phone").eq("id", order.branch_id).maybeSingle();
  const { data: lines } = await db.from("order_items").select("name_en, name_ar, qty, modifiers").eq("order_id", order.id);

  return json({
    ok: true,
    order: {
      order_no: order.order_no, status: order.status, total: Number(order.total),
      eta: order.pickup_eta_minutes, accepted_at: order.accepted_at, ready_at: order.ready_at,
      reject_reason: order.reject_reason, created_at: order.created_at, customer_name: order.customer_name,
    },
    branch: branch ?? null,
    items: lines ?? [],
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  let body: any = {};
  try { body = await req.json(); } catch { /* empty body -> unknown action */ }
  const db = admin();
  try {
    switch (body?.action) {
      case "menu":  return await doMenu(db, body?.branch_id ?? null);
      case "place": return await doPlace(db, body);
      case "track": return await doTrack(db, String(body?.token || ""));
      default:      return fail("Unknown action", 400);
    }
  } catch (_e) {
    // Never echo the raw error: it can carry row contents or connection detail.
    return fail("Something went wrong. Please try again.", 500);
  }
});
