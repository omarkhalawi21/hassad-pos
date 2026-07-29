// Supabase Edge Function: koinz
//
// The ONLY place the Koinz `api-key` lives. The POS is a public static page,
// so every Koinz call is proxied here. Loyalty is OUTBOUND-ONLY (points +
// gift redemption) -- no webhooks, no public order intake.
//
// Required secrets (Supabase Dashboard -> Edge Functions -> Manage Secrets, or
//   `supabase secrets set KOINZ_API_KEY=... KOINZ_BASE_URL=...`):
//   KOINZ_API_KEY   -- per-merchant key Koinz issues on account creation
//   KOINZ_BASE_URL  -- https://api-sandbox.pos.koinz.app (staging) or
//                      https://api.pos.koinz.app (production)
// SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are injected automatically.
//
// Actions (POST { action, ... }):
//   flush     -> send all pending/retryable points ops as ONE batch to
//                add-points; mark each synced/failed from failed_operations.
//   validate  -> validate a gift code; returns customer + gift.
//   redeem    -> redeem a validated gift code; logs koinz_redemptions.
//   delete    -> delete a points operation (used on void/return).

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, "Content-Type": "application/json" } });

const BASE = (Deno.env.get("KOINZ_BASE_URL") || "https://api-sandbox.pos.koinz.app").replace(/\/+$/, "");
const API_KEY = Deno.env.get("KOINZ_API_KEY") || "";
const FLUSH_LIMIT = 200;

// POST JSON to a Koinz endpoint with the api-key header. Returns the HTTP
// status plus the parsed body (or raw text when it isn't JSON).
async function koinz(path: string, body: unknown): Promise<{ status: number; data: any; raw: string }> {
  const res = await fetch(`${BASE}${path}`, {
    method: "POST",
    headers: { "api-key": API_KEY, "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const raw = await res.text();
  let data: any = null;
  try { data = raw ? JSON.parse(raw) : null; } catch { /* non-JSON body */ }
  return { status: res.status, data, raw };
}

const admin = () =>
  createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { persistSession: false },
  });

// ---- flush: send the points outbox ------------------------------------------
// Reads every op that is still owed (pending, or failed-but-retryable), sends
// them UNCHANGED (same operation_id + timestamp -- Koinz dedupes on that), and
// records the outcome. On a non-200 the whole batch stays owed and is resent
// next flush (Koinz's mandated durable-outbox behaviour).
async function doFlush() {
  const db = admin();
  const { data: rows, error } = await db
    .from("koinz_operations")
    .select("*")
    .in("status", ["pending", "failed"])
    .eq("should_retry", true)
    .order("created_at", { ascending: true })
    .limit(FLUSH_LIMIT);
  if (error) return json({ error: error.message }, 500);
  if (!rows || rows.length === 0) return json({ sent: 0, synced: 0, failed: 0, pending: 0 });

  const operations = rows.map((r: any) => ({
    operation_id: r.operation_id,
    branch_integration_id: r.branch_id,
    cashier_integration_id: r.cashier_id,
    receipt_value: Math.round(Number(r.receipt_value) || 0), // spec type is int (local currency)
    receipt_code: r.receipt_code || "",
    timestamp: Number(r.op_timestamp),
    phone_number: r.phone_number,
    country_code: r.country_code || "+966",
  }));

  const nowIso = new Date().toISOString();
  const { status, data, raw } = await koinz("/api/pos/v2.0/add-points", { operations });

  if (status !== 200) {
    // Whole batch failed -> keep every op owed, record the error, bump attempts.
    const msg = `HTTP ${status}: ${(raw || "").slice(0, 300)}`;
    await Promise.all(rows.map((r: any) =>
      db.from("koinz_operations").update({
        status: "failed", should_retry: true, last_error: msg, attempts: (r.attempts || 0) + 1,
      }).eq("operation_id", r.operation_id)
    ));
    return json({ sent: rows.length, synced: 0, failed: rows.length, error: msg }, 200);
  }

  // 200 -> failed_operations lists only the ones Koinz couldn't take. Everything
  // else in the batch succeeded.
  const failedList: any[] = Array.isArray(data?.failed_operations) ? data.failed_operations : [];
  const failedById = new Map<string, any>();
  for (const f of failedList) failedById.set(f.operation_id || f.id, f);

  let synced = 0, failed = 0;
  await Promise.all(rows.map((r: any) => {
    const f = failedById.get(r.operation_id);
    if (f) {
      failed++;
      return db.from("koinz_operations").update({
        status: "failed",
        should_retry: f.should_retry !== false,
        last_error: String(f.reason || "rejected by Koinz"),
        attempts: (r.attempts || 0) + 1,
      }).eq("operation_id", r.operation_id);
    }
    synced++;
    return db.from("koinz_operations").update({
      status: "synced", synced_at: nowIso, last_error: null, attempts: (r.attempts || 0) + 1,
    }).eq("operation_id", r.operation_id);
  }));

  return json({ sent: rows.length, synced, failed });
}

// ---- validate / redeem / delete ---------------------------------------------
async function doValidate(p: any) {
  if (!p.redeem_code) return json({ error: "redeem_code is required" }, 400);
  const { status, data, raw } = await koinz("/api/pos/v2.0/validate-redeem-code", {
    redeem_code: String(p.redeem_code).trim(),
    cashier_integration_id: p.cashier_integration_id || null,
  });
  if (status === 200) {
    const gift = data?.item || data?.special_item || null;
    return json({
      ok: true,
      customer_name: data?.customer?.name || null,
      gift: gift ? { name: gift.name || null, price: gift.price ?? null, image: gift.image || null,
                     integration_id: gift.integration_id || gift.id || null } : null,
      raw: data,
    });
  }
  if (status === 403) return json({ ok: false, invalid: true, message: "Invalid gift code" }, 200);
  return json({ ok: false, message: `HTTP ${status}: ${(raw || "").slice(0, 200)}` }, 200);
}

async function doRedeem(p: any) {
  if (!p.redeem_code) return json({ error: "redeem_code is required" }, 400);
  const { status, raw } = await koinz("/api/pos/v2.0/redeem-reward", {
    redeem_code: String(p.redeem_code).trim(),
    cashier_integration_id: p.cashier_integration_id || null,
  });
  const ok = status === 200;
  // Log the redemption regardless (redeemed / failed) for the branch audit.
  try {
    await admin().from("koinz_redemptions").insert({
      redeem_code: String(p.redeem_code).trim(),
      branch_id: p.branch_id || null,
      cashier_id: p.cashier_integration_id || null,
      customer_name: p.customer_name || null,
      gift_name: p.gift_name || null,
      gift_price: p.gift_price ?? null,
      status: ok ? "redeemed" : "failed",
    });
  } catch { /* logging must never block the redeem result */ }
  if (ok) return json({ ok: true });
  if (status === 403) return json({ ok: false, invalid: true, message: "Invalid gift code" }, 200);
  return json({ ok: false, message: `HTTP ${status}: ${(raw || "").slice(0, 200)}` }, 200);
}

async function doDelete(p: any) {
  if (!p.operation_integration_id) return json({ error: "operation_integration_id is required" }, 400);
  const { status, raw } = await koinz("/api/pos/v2.1/delete-points-operation", {
    operation_integration_id: p.operation_integration_id,
  });
  return json({ ok: status === 200, status, message: status === 200 ? "" : (raw || "").slice(0, 200) }, 200);
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);
  if (!API_KEY) return json({ error: "KOINZ_API_KEY not configured on the Edge Function" }, 500);

  let p: any;
  try { p = await req.json(); } catch { return json({ error: "Invalid JSON body" }, 400); }
  const action = p?.action;
  try {
    switch (action) {
      case "flush":    return await doFlush();
      case "validate": return await doValidate(p);
      case "redeem":   return await doRedeem(p);
      case "delete":   return await doDelete(p);
      default:         return json({ error: `Unknown action: ${action}` }, 400);
    }
  } catch (e) {
    return json({ error: e instanceof Error ? e.message : String(e) }, 500);
  }
});
