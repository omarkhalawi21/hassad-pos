# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this is

**Hassad POS** — point-of-sale for Hassad Coffee Roasters. A single deployable `index.html` (plain HTML + vanilla JS, no framework, no bundler) with two surfaces: a touch-first **POS console** (cashiers, branch-locked) and an **admin side** (menu, branches, staff, dashboard). Backend is its own Supabase project (Auth + Postgres) — **separate from the Hassad HR app's project**, but the codebase deliberately mirrors the HR app's conventions (`/Users/arbaaz/Documents/Claude/Projects/HUMAN RESOURCE APP`).

## Commands

```bash
npm install     # once per machine (only dependency is tailwindcss)
npm run build   # rebuild tailwind.css when index.html gains new utility classes
npm run watch   # rebuild on save
```

- Compiled `tailwind.css` is **committed and served as-is**; rebuild only when adding new utilities, and commit the result.
- **No test runner.** The correctness gate: extract the inline `<script>` body from `index.html` and run `node --check` on it. Always do this after editing.
- Deploy = GitHub Pages serving the repo root; merging only ships frontend.

## SQL migration workflow (most important rule)

`supabase-pos.sql` is the schema + RLS source of truth: **append-only numbered blocks, fully idempotent** (safe to re-paste whole). It is **run manually** in the Supabase SQL editor — never assume a merge migrated anything. Front-load required SQL in the PR body and in chat as a pre-merge step, and have the user run the diagnostic at the file's end afterward ("Success. No rows returned" proves nothing). Unlike the HR app's file, this one creates ALL its tables from scratch — keep it that way.

## Architecture conventions (ported from the HR app)

- **Roles:** `staff.role` ∈ admin | manager | cashier — single source of truth. SQL helpers `is_admin()`, `has_role(text[])`, `my_branch_id()`; JS `currentRole()`, `hasRole(...)`, `isAdmin()`. Cashiers are branch-locked **by RLS**, not just UI. Nav visibility is never the security boundary — every route re-gates in `render()`'s switch, and RLS enforces server-side.
- **DB ↔ JS mapping:** every table has `mapXFromDb` (snake→camel) / `xToDb` (camel→snake) with Number coercion. Never read raw snake_case elsewhere.
- **Modals:** `openModal(title, bodyHTML, onSave, opts)` / `closeModal()`. Any transient module-level `let` (cart draft, pending upload) must be reset in BOTH `closeModal()` and `logout()` — shared-tablet hygiene.
- **Render:** hash routes in the `routes` array → `render()` switch → full innerHTML replace. New page = routes entry + switch case + navItems entry with `show:` role gate.
- **Prices are VAT-inclusive** (KSA retail). VAT portion derived: `total * rate / (100 + rate)`. Receipts carry the ZATCA Phase-1 TLV QR (`zatcaQrDataUrl`) — tags 1–5, seller legal name + VAT number from `pos_settings`.
- **Order numbers** restart per branch per business day, assigned by DB trigger; on unique-violation (concurrent cashiers) the app retries the insert once.
- **CDN libs pinned + SRI-hashed** (supabase-js, qrcode-generator), every use guarded by `typeof X` so a CDN blip degrades (receipt without QR) instead of crashing. New external scripts require a CSP allowlist update in the `<meta>` tag.
- **Print** uses Blob + `URL.createObjectURL` popups (`openPrintWindow`), never `document.write` into `about:blank` — Safari saves blank PDFs otherwise.
- The publishable Supabase key in `index.html` is safe **only** because RLS is airtight on every table. Never weaken a policy for convenience.

## Bootstrap facts

- The **first-ever auth signup** on an empty `staff` table becomes the admin (DB trigger) — the owner must sign up first on a fresh project.
- Staff accounts are pre-provisioned by the admin (email match links on signup, case-insensitive, set-once `user_id`).
