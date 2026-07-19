# Restoring from an automated backup

The nightly `.github/workflows/backup.yml` produces an encrypted gzipped SQL dump of the **public schema** for every day, attached to a dated GitHub Release tag named `backup-YYYY-MM-DDTHH-MM-SSZ`. The last 30 days are kept; older ones are pruned automatically.

This file is the **restore drill**. Walk it through end-to-end at least once *before* you ever need it in anger — on the day something breaks, the steps should feel familiar, not novel.

---

## What's in the backup (and what isn't)

### Included

- Every table in the `public` schema with all rows: `staff`, `pos_settings`, `branches`, `menu_categories`, `menu_items`, `menu_item_branch_off`, `menu_groups`, `item_menu_groups`, `modifier_groups`, `modifier_options`, `item_modifier_groups`, `orders`, `order_items`, `order_payments`, `shifts`, `shift_movements`, `devices`, `device_categories`, `pos_roles`, `staff_roles`, `payment_methods`.
- All RLS policies + check constraints + triggers + functions in the `public` schema (same as re-running `supabase-pos.sql`).

### NOT included

- **`auth.users`** — Supabase Auth accounts (emails, hashed passwords) live in the `auth` schema, which the workflow deliberately skips. On a fresh project those accounts don't exist yet; each staff member simply uses **"Create account"** on the login screen again with the same email — the app links the new auth user to their existing `staff` row automatically. (`staff.user_id` values from the old project are stale after that; the signup flow overwrites them.)
- **Supabase Storage objects** — not used; product photos are external URLs / inline data.

For "I made a mistake in the last few hours and need one table back", see **partial restore** below.

---

## Full restore — happy path

**You need**: `gpg`, `gunzip`, `psql` (Postgres client 14+), the `BACKUP_PASSPHRASE` from your password manager, and a destination Supabase project.

### Step 1 — Download

Repo **Releases** page → find `backup-<stamp>` → download the `.sql.gz.gpg` artifact. Or:

```bash
gh release download backup-2026-08-01T01-00-00Z \
  --repo omarkhalawi21/hassad-pos \
  --pattern "*.sql.gz.gpg"
```

### Step 2 — Decrypt + decompress

```bash
gpg --decrypt --output backup.sql.gz hassad-pos-backup-<stamp>.sql.gz.gpg
# enter BACKUP_PASSPHRASE when prompted
gunzip backup.sql.gz          # produces backup.sql
```

### Step 3 — Restore into the destination

⚠️ **Never restore straight onto prod first.** Create a scratch Supabase project, restore there, eyeball the data, then decide.

Use the **direct** connection string (port 5432, not 6543) of the destination:

```bash
psql "postgresql://postgres:<password>@db.<ref>.supabase.co:5432/postgres" \
  -v ON_ERROR_STOP=0 -f backup.sql
```

The dump was taken with `--clean --if-exists`, so it drops and recreates each object; harmless "does not exist, skipping" notices on a fresh project are expected.

### Step 4 — Re-apply the migration file

Paste the entire `supabase-pos.sql` into the destination's SQL editor and run it. It's fully idempotent — this guarantees helper functions, policies and seeds match the app version even if the dump predates a migration.

### Step 5 — Point the app (only if switching projects)

`index.html` → `SUPABASE_URL` / publishable key near the top of the inline script → commit + push. Staff re-create their accounts (see "NOT included" above).

---

## Partial restore — one table / a few rows

Restore the dump into a **scratch project** (steps 1–3), then copy the rows you need back to prod by hand — via the Supabase table editor, or a `COPY (...) TO STDOUT` / `\copy` pair, or a targeted `INSERT ... SELECT` over a foreign data wrapper if you're comfortable. Never run the full dump against prod for a one-table mistake: `--clean` would drop *everything* first.

---

## Verifying a backup is healthy (monthly, 2 minutes)

```bash
gpg --decrypt --output /dev/stdout <artifact>.sql.gz.gpg | gunzip | grep -c 'CREATE TABLE'
```

Expect ~21+. If decryption fails, the passphrase in GitHub Secrets and your password manager have drifted — fix that **today**, not on restore day.
