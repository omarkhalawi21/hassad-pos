-- ============================================================
-- HASSAD POS -- schema + RLS source of truth
--
-- Rules (same discipline as the Hassad HR app):
--   * Append-only and numbered: new schema goes in a new numbered
--     block at the end, before the DONE marker. Never rewrite
--     earlier blocks.
--   * Fully idempotent: CREATE TABLE IF NOT EXISTS, CREATE OR
--     REPLACE, drop-then-create policies in DO $$ loops, seeds
--     guarded by WHERE NOT EXISTS. Re-running the whole file on a
--     partially-migrated DB is safe.
--   * Running this file is MANUAL: paste into the Supabase SQL
--     editor. Merging a PR ships only frontend.
--   * After running, execute the diagnostic at the bottom --
--     "Success. No rows returned" from the DDL proves nothing.
--
-- Security model: the publishable key ships in index.html; that is
-- safe ONLY because every table enforces RLS. Never weaken it.
-- ============================================================

-- =============================================================
-- 1. STAFF + ROLE HELPERS
--    Roles: admin (owner -- everything), manager (branch manager --
--    menu + reports for their branch), cashier (POS console only,
--    locked to their branch). staff.user_id links to auth.users
--    with SET-ONCE semantics (NULL->UUID allowed, any other change
--    blocked) -- the HR app learned the hard way that a blanket
--    "immutable" trigger breaks the auth-signup linker.
-- =============================================================
CREATE TABLE IF NOT EXISTS public.staff (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid unique references auth.users(id) on delete set null,
  email       text not null unique,
  first_name  text not null default '',
  last_name   text not null default '',
  role        text not null default 'cashier'
    CHECK (role IN ('admin','manager','cashier')),
  branch_id   uuid,                -- fk added in block 2 (branches)
  active      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $fn$
  SELECT EXISTS (
    SELECT 1 FROM public.staff
    WHERE user_id = auth.uid() AND role = 'admin' AND active
  );
$fn$;

CREATE OR REPLACE FUNCTION public.has_role(roles text[])
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $fn$
  SELECT EXISTS (
    SELECT 1 FROM public.staff
    WHERE user_id = auth.uid() AND role = ANY(roles) AND active
  );
$fn$;

-- Current staff row's branch (NULL for admins without a branch).
CREATE OR REPLACE FUNCTION public.my_branch_id()
RETURNS uuid LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $fn$
  SELECT branch_id FROM public.staff WHERE user_id = auth.uid() AND active;
$fn$;

-- Link a fresh auth.users signup to its pre-created staff row by
-- email (case-insensitive -- auth lowercases, rows may not). Two paths:
--   1. BOOTSTRAP: the very first auth user on an empty staff table
--      becomes the admin (do this signup yourself before anyone else).
--   2. LINK: admin pre-created the staff row -> NULL->UUID set-once link.
-- Unknown emails get no row: POS accounts are provisioned by the
-- admin first; random signups stay locked out by RLS.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $fn$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.staff) THEN
    INSERT INTO public.staff (user_id, email, first_name, last_name, role, active)
    VALUES (NEW.id, lower(NEW.email),
            coalesce(NEW.raw_user_meta_data->>'first_name',''),
            coalesce(NEW.raw_user_meta_data->>'last_name',''),
            'admin', true);
  ELSE
    UPDATE public.staff
       SET user_id = NEW.id, updated_at = now()
     WHERE lower(email) = lower(NEW.email) AND user_id IS NULL;
  END IF;
  RETURN NEW;
END;
$fn$;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Set-once user_id + self-role-change block.
CREATE OR REPLACE FUNCTION public.enforce_staff_update_rules()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $fn$
BEGIN
  -- user_id: NULL->UUID allowed (linker); UUID->anything blocked.
  IF OLD.user_id IS NOT NULL AND NEW.user_id IS DISTINCT FROM OLD.user_id THEN
    RAISE EXCEPTION 'staff.user_id is set-once';
  END IF;
  -- No self-promotion: changing your own role requires another admin.
  IF OLD.user_id = auth.uid() AND NEW.role IS DISTINCT FROM OLD.role THEN
    RAISE EXCEPTION 'you cannot change your own role';
  END IF;
  NEW.updated_at = now();
  RETURN NEW;
END;
$fn$;
DROP TRIGGER IF EXISTS enforce_staff_update_rules_trigger ON public.staff;
CREATE TRIGGER enforce_staff_update_rules_trigger
  BEFORE UPDATE ON public.staff
  FOR EACH ROW EXECUTE FUNCTION public.enforce_staff_update_rules();

ALTER TABLE public.staff ENABLE ROW LEVEL SECURITY;
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT schemaname, tablename, policyname FROM pg_policies
           WHERE schemaname='public' AND tablename='staff' LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', r.policyname, r.schemaname, r.tablename);
  END LOOP;
END $$;
-- Everyone signed in can see the staff list (names for receipts/
-- dashboards); only admin writes.
CREATE POLICY "staff_select_authenticated"
  ON public.staff FOR SELECT TO authenticated USING (true);
CREATE POLICY "staff_insert_admin"
  ON public.staff FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "staff_update_admin_or_linker"
  ON public.staff FOR UPDATE TO authenticated
  USING (public.is_admin() OR user_id IS NULL)
  WITH CHECK (public.is_admin() OR user_id = auth.uid());
CREATE POLICY "staff_delete_admin"
  ON public.staff FOR DELETE TO authenticated USING (public.is_admin());

-- =============================================================
-- 2. SETTINGS + BRANCHES
--    pos_settings is a single-row table (seeded below). vat_number
--    feeds the ZATCA Phase-1 QR on every receipt.
-- =============================================================
CREATE TABLE IF NOT EXISTS public.pos_settings (
  id                uuid primary key default gen_random_uuid(),
  company_name      text not null default 'Hassad Coffee Roasters',
  company_name_ar   text not null default 'شركة حصاد الخبر للتجارة',
  vat_number        text not null default '',
  cr_number         text not null default '7021976688',
  currency          text not null default 'SAR',
  vat_rate          numeric(5,2) not null default 15.00,
  receipt_footer_en text not null default 'Thank you -- every cup begins with the harvest.',
  receipt_footer_ar text not null default 'شكراً لكم -- كل فنجان يبدأ من الحصاد.',
  updated_at        timestamptz not null default now()
);
INSERT INTO public.pos_settings (company_name)
SELECT 'Hassad Coffee Roasters'
WHERE NOT EXISTS (SELECT 1 FROM public.pos_settings);

CREATE TABLE IF NOT EXISTS public.branches (
  id          uuid primary key default gen_random_uuid(),
  name        text not null unique,
  name_ar     text not null default '',
  active      boolean not null default true,
  created_at  timestamptz not null default now()
);
INSERT INTO public.branches (name)
SELECT v.name FROM (VALUES ('KHOBAR'), ('RAYYAN'), ('FAISALIYAH')) AS v(name)
WHERE NOT EXISTS (SELECT 1 FROM public.branches b WHERE b.name = v.name);

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                 WHERE constraint_name='staff_branch_id_fkey' AND table_name='staff') THEN
    ALTER TABLE public.staff
      ADD CONSTRAINT staff_branch_id_fkey
      FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE SET NULL;
  END IF;
END $$;

ALTER TABLE public.pos_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branches     ENABLE ROW LEVEL SECURITY;
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT schemaname, tablename, policyname FROM pg_policies
           WHERE schemaname='public' AND tablename IN ('pos_settings','branches') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', r.policyname, r.schemaname, r.tablename);
  END LOOP;
END $$;
CREATE POLICY "pos_settings_select_authenticated"
  ON public.pos_settings FOR SELECT TO authenticated USING (true);
CREATE POLICY "pos_settings_update_admin"
  ON public.pos_settings FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "pos_settings_insert_admin"
  ON public.pos_settings FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "pos_settings_delete_admin"
  ON public.pos_settings FOR DELETE TO authenticated USING (public.is_admin());
CREATE POLICY "branches_select_authenticated"
  ON public.branches FOR SELECT TO authenticated USING (true);
CREATE POLICY "branches_insert_admin"
  ON public.branches FOR INSERT TO authenticated WITH CHECK (public.is_admin());
CREATE POLICY "branches_update_admin"
  ON public.branches FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY "branches_delete_admin"
  ON public.branches FOR DELETE TO authenticated USING (public.is_admin());

-- =============================================================
-- 3. MENU -- categories, items, per-branch availability
--    Prices are VAT-INCLUSIVE (KSA retail convention). The VAT
--    portion is derived at checkout: total * rate / (100 + rate).
-- =============================================================
CREATE TABLE IF NOT EXISTS public.menu_categories (
  id          uuid primary key default gen_random_uuid(),
  name_en     text not null,
  name_ar     text not null default '',
  sort_order  int  not null default 0,
  active      boolean not null default true,
  created_at  timestamptz not null default now()
);
CREATE TABLE IF NOT EXISTS public.menu_items (
  id          uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.menu_categories(id) on delete restrict,
  name_en     text not null,
  name_ar     text not null default '',
  price       numeric(12,2) not null CHECK (price >= 0),   -- VAT-inclusive
  sku         text,
  sort_order  int  not null default 0,
  active      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
CREATE INDEX IF NOT EXISTS menu_items_category_idx ON public.menu_items(category_id);

-- An item is available everywhere by default; a row here turns it
-- OFF for one branch (absence = available). Keeps the common case
-- rowless.
CREATE TABLE IF NOT EXISTS public.menu_item_branch_off (
  item_id    uuid not null references public.menu_items(id) on delete cascade,
  branch_id  uuid not null references public.branches(id) on delete cascade,
  PRIMARY KEY (item_id, branch_id)
);

ALTER TABLE public.menu_categories       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_items            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_item_branch_off  ENABLE ROW LEVEL SECURITY;
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT schemaname, tablename, policyname FROM pg_policies
           WHERE schemaname='public'
             AND tablename IN ('menu_categories','menu_items','menu_item_branch_off') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', r.policyname, r.schemaname, r.tablename);
  END LOOP;
END $$;
-- Menu readable by all signed-in staff (the console needs it);
-- writable by admin + manager.
CREATE POLICY "menu_categories_select_authenticated"
  ON public.menu_categories FOR SELECT TO authenticated USING (true);
CREATE POLICY "menu_categories_insert_roles"
  ON public.menu_categories FOR INSERT TO authenticated WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "menu_categories_update_roles"
  ON public.menu_categories FOR UPDATE TO authenticated
  USING (public.has_role(ARRAY['admin','manager'])) WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "menu_categories_delete_roles"
  ON public.menu_categories FOR DELETE TO authenticated USING (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "menu_items_select_authenticated"
  ON public.menu_items FOR SELECT TO authenticated USING (true);
CREATE POLICY "menu_items_insert_roles"
  ON public.menu_items FOR INSERT TO authenticated WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "menu_items_update_roles"
  ON public.menu_items FOR UPDATE TO authenticated
  USING (public.has_role(ARRAY['admin','manager'])) WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "menu_items_delete_roles"
  ON public.menu_items FOR DELETE TO authenticated USING (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "menu_item_branch_off_select_authenticated"
  ON public.menu_item_branch_off FOR SELECT TO authenticated USING (true);
CREATE POLICY "menu_item_branch_off_insert_roles"
  ON public.menu_item_branch_off FOR INSERT TO authenticated WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "menu_item_branch_off_update_roles"
  ON public.menu_item_branch_off FOR UPDATE TO authenticated
  USING (public.has_role(ARRAY['admin','manager'])) WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "menu_item_branch_off_delete_roles"
  ON public.menu_item_branch_off FOR DELETE TO authenticated USING (public.has_role(ARRAY['admin','manager']));

-- =============================================================
-- 4. ORDERS + LINES + PAYMENTS
--    order_no restarts per branch per business day (receipt-friendly
--    "#47"), assigned by trigger under UNIQUE(branch_id,
--    business_date, order_no) -- concurrent cashiers on one branch
--    retry in the app on unique violation (rare at coffee volume).
--    Cashiers write orders ONLY for their own branch; snapshots of
--    item name + price live on the line so menu edits never rewrite
--    history. Payments: sum(amount) must equal orders.total --
--    enforced in the app; the DB keeps method sanity.
-- =============================================================
CREATE TABLE IF NOT EXISTS public.orders (
  id            uuid primary key default gen_random_uuid(),
  branch_id     uuid not null references public.branches(id) on delete restrict,
  business_date date not null default current_date,
  order_no      int,
  status        text not null default 'completed'
    CHECK (status IN ('completed','void')),
  subtotal      numeric(12,2) not null default 0,   -- ex-VAT
  vat_amount    numeric(12,2) not null default 0,
  total         numeric(12,2) not null default 0,   -- VAT-inclusive
  cashier_id    uuid references public.staff(id),
  void_reason   text,
  created_at    timestamptz not null default now()
);
CREATE UNIQUE INDEX IF NOT EXISTS orders_branch_day_no_idx
  ON public.orders(branch_id, business_date, order_no);
CREATE INDEX IF NOT EXISTS orders_created_idx ON public.orders(created_at DESC);

CREATE OR REPLACE FUNCTION public.assign_order_no()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $fn$
BEGIN
  IF NEW.order_no IS NULL THEN
    SELECT coalesce(max(order_no), 0) + 1 INTO NEW.order_no
      FROM public.orders
     WHERE branch_id = NEW.branch_id AND business_date = NEW.business_date;
  END IF;
  RETURN NEW;
END;
$fn$;
DROP TRIGGER IF EXISTS assign_order_no_trigger ON public.orders;
CREATE TRIGGER assign_order_no_trigger
  BEFORE INSERT ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.assign_order_no();

CREATE TABLE IF NOT EXISTS public.order_items (
  id          uuid primary key default gen_random_uuid(),
  order_id    uuid not null references public.orders(id) on delete cascade,
  item_id     uuid references public.menu_items(id) on delete set null,
  name_en     text not null,                          -- snapshot at sale time
  name_ar     text not null default '',
  unit_price  numeric(12,2) not null,                 -- VAT-inclusive snapshot
  qty         numeric(8,2) not null CHECK (qty > 0),
  line_total  numeric(12,2) not null
);
CREATE INDEX IF NOT EXISTS order_items_order_idx ON public.order_items(order_id);

CREATE TABLE IF NOT EXISTS public.order_payments (
  id           uuid primary key default gen_random_uuid(),
  order_id     uuid not null references public.orders(id) on delete cascade,
  method       text not null
    CHECK (method IN ('cash','mada','card','stc_pay','other')),
  amount       numeric(12,2) not null CHECK (amount >= 0),
  tendered     numeric(12,2),   -- cash only: what the customer handed over
  change_given numeric(12,2),   -- cash only
  created_at   timestamptz not null default now()
);
CREATE INDEX IF NOT EXISTS order_payments_order_idx ON public.order_payments(order_id);

ALTER TABLE public.orders         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_payments ENABLE ROW LEVEL SECURITY;
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT schemaname, tablename, policyname FROM pg_policies
           WHERE schemaname='public'
             AND tablename IN ('orders','order_items','order_payments') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', r.policyname, r.schemaname, r.tablename);
  END LOOP;
END $$;
-- Reads: admin/manager see everything; cashiers see their own
-- branch's orders (needed for reprint + "today so far").
CREATE POLICY "orders_select_scoped"
  ON public.orders FOR SELECT TO authenticated
  USING (public.has_role(ARRAY['admin','manager']) OR branch_id = public.my_branch_id());
-- Writes: any active staff may create an order, but ONLY for their
-- own branch -- admins/managers may create for any branch.
CREATE POLICY "orders_insert_scoped"
  ON public.orders FOR INSERT TO authenticated
  WITH CHECK (
    public.has_role(ARRAY['admin','manager'])
    OR (public.has_role(ARRAY['cashier']) AND branch_id = public.my_branch_id())
  );
-- Voiding = UPDATE status; admin/manager only. Order rows are never
-- deleted -- voided orders keep the audit trail.
CREATE POLICY "orders_update_roles"
  ON public.orders FOR UPDATE TO authenticated
  USING (public.has_role(ARRAY['admin','manager']))
  WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "orders_delete_admin"
  ON public.orders FOR DELETE TO authenticated USING (public.is_admin());
CREATE POLICY "order_items_select_scoped"
  ON public.order_items FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.orders o WHERE o.id = order_id
                 AND (public.has_role(ARRAY['admin','manager']) OR o.branch_id = public.my_branch_id())));
CREATE POLICY "order_items_insert_scoped"
  ON public.order_items FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM public.orders o WHERE o.id = order_id
                      AND (public.has_role(ARRAY['admin','manager']) OR o.branch_id = public.my_branch_id())));
CREATE POLICY "order_items_update_roles"
  ON public.order_items FOR UPDATE TO authenticated
  USING (public.has_role(ARRAY['admin','manager']))
  WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "order_items_delete_admin"
  ON public.order_items FOR DELETE TO authenticated USING (public.is_admin());
CREATE POLICY "order_payments_select_scoped"
  ON public.order_payments FOR SELECT TO authenticated
  USING (EXISTS (SELECT 1 FROM public.orders o WHERE o.id = order_id
                 AND (public.has_role(ARRAY['admin','manager']) OR o.branch_id = public.my_branch_id())));
CREATE POLICY "order_payments_insert_scoped"
  ON public.order_payments FOR INSERT TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM public.orders o WHERE o.id = order_id
                      AND (public.has_role(ARRAY['admin','manager']) OR o.branch_id = public.my_branch_id())));
CREATE POLICY "order_payments_update_roles"
  ON public.order_payments FOR UPDATE TO authenticated
  USING (public.has_role(ARRAY['admin','manager']))
  WITH CHECK (public.has_role(ARRAY['admin','manager']));
CREATE POLICY "order_payments_delete_admin"
  ON public.order_payments FOR DELETE TO authenticated USING (public.is_admin());

-- =============================================================
-- 5. ORDER TYPES, DISCOUNTS, RETURNS (shift-parity with Foodics)
--    * order_type: every order carries pickup / dine_in / delivery /
--      drive_thru (Foodics dashboard breaks sales down by these).
--    * Discounts: applied to the VAT-inclusive gross BEFORE the VAT
--      portion is derived (KSA VAT is owed on the consideration
--      actually charged). Stored as final amount + reason.
--    * Returns: full-order, post-payment (distinct from 'void' =
--      pre-handover mistake). status='returned' keeps the row for
--      the audit trail; reports subtract it from net sales.
-- =============================================================
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS order_type text not null default 'pickup';
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS discount_amount numeric(12,2) not null default 0;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS discount_reason text;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS returned_at timestamptz;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS returned_by uuid references public.staff(id);

ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_status_check;
ALTER TABLE public.orders ADD CONSTRAINT orders_status_check
  CHECK (status IN ('completed','void','returned'));
ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_order_type_check;
ALTER TABLE public.orders ADD CONSTRAINT orders_order_type_check
  CHECK (order_type IN ('pickup','dine_in','delivery','drive_thru'));
ALTER TABLE public.orders DROP CONSTRAINT IF EXISTS orders_discount_check;
ALTER TABLE public.orders ADD CONSTRAINT orders_discount_check
  CHECK (discount_amount >= 0);

-- =============================================================
-- DONE.
--
-- Diagnostic -- run after pasting; expect one row of counts that
-- match: 9 tables / 32+ policies / 3 branches / 1 settings row.
--
--   SELECT
--     (SELECT count(*) FROM information_schema.tables
--       WHERE table_schema='public' AND table_name IN
--       ('staff','pos_settings','branches','menu_categories','menu_items',
--        'menu_item_branch_off','orders','order_items','order_payments')) AS tables_ok,
--     (SELECT count(*) FROM pg_policies WHERE schemaname='public') AS policy_count,
--     (SELECT count(*) FROM public.branches) AS branch_count,
--     (SELECT count(*) FROM public.pos_settings) AS settings_rows;
-- =============================================================
