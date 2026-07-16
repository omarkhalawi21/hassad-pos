# Hassad POS

Point-of-sale system for Hassad Coffee Roasters. Two surfaces in one deployable static app:

- **POS console** — touch-first cashier screen per branch: category tabs, item grid, cart, checkout with cash / mada / split payment, 80mm thermal receipt with ZATCA Phase-1 QR.
- **Admin side** — menu & category management, branches, staff accounts with roles, sales dashboard.

## Stack

Same battle-tested architecture as the Hassad HR app:

- Plain HTML + vanilla JS, no framework, no bundler — one deployable `index.html`
- Supabase (Auth + Postgres + Realtime) — **its own project, separate from the HR app**
- Row Level Security on every table; the publishable key in the frontend is safe *only* because of that
- Tailwind (compiled `tailwind.css` committed; `npm run build` to regenerate)
- Deployed static to GitHub Pages

## Setup

1. Create a Supabase project, paste `supabase-pos.sql` into its SQL editor, run, then run the diagnostic query at the bottom.
2. Put the project URL + publishable key in `index.html` (`SUPABASE_URL` / `SUPABASE_ANON_KEY`).
3. Serve `index.html` (GitHub Pages or any static host).

## Development

```bash
npm install        # once per machine
npm run build      # rebuild tailwind.css when new utility classes are added
npm run watch      # rebuild on save
```

Before committing changes to `index.html`: extract the inline `<script>` body and run `node --check` on it.

`supabase-pos.sql` is append-only and idempotent — new schema goes in a new numbered block at the end; the whole file is safe to re-run.
