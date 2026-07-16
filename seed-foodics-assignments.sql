-- ============================================================
-- SEED: REAL product<->modifier assignments from the Foodics
-- products_modifiers export (263649, 2026-07-16). Replaces the
-- heuristic assignments seeded earlier with the exact truth:
-- per-product min/max and default options.
-- Idempotent: wipes assignments only for the products in this export,
-- then re-inserts them.
-- ============================================================

DELETE FROM public.item_modifier_groups
 WHERE item_id IN (SELECT id FROM public.menu_items WHERE sku IN ('sk-0003','sk-0004','sk-0005','sk-0006','sk-0007','sk-0008','sk-0009','sk-0010','sk-0011','sk-0012','sk-0082','sk-0114','sk-0142','sk-0161','sk-0188','sk-0190','sk-0191','sk-0221','sk-0232','sk-0233','sk-0244','sk-0249','sk-0258','sk-0259','sk-0260','sk-0261','sk-0262','sk-0263','sk-0264','sk-0267','sk-0273','sk-0275','sk-0281','sk-0284','sk-0292','sk-0298','sk-0339','sk-0346','sk-0349','sk-0350','sk-0351','sk-0352','sk-0353','sk-0377','sk-0381','sk-0384'));

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0004'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0005'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0007'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0008'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0009'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0010'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0011'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0114'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0161'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0258'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0259'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0260'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0261'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0262'
  AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0004'
  AND lower(g.name_en) = lower('MILK') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, (SELECT o.id FROM public.modifier_options o WHERE o.sku = 'sk-0165' LIMIT 1)
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0005'
  AND lower(g.name_en) = lower('MILK') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0007'
  AND lower(g.name_en) = lower('MILK') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, (SELECT o.id FROM public.modifier_options o WHERE o.sku = 'sk-0165' LIMIT 1)
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0008'
  AND lower(g.name_en) = lower('MILK') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 7, (SELECT o.id FROM public.modifier_options o WHERE o.sku = 'sk-0165' LIMIT 1)
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0010'
  AND lower(g.name_en) = lower('MILK') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0082'
  AND lower(g.name_en) = lower('MILK') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0010'
  AND lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, (SELECT o.id FROM public.modifier_options o WHERE o.sku = 'sk-0113' LIMIT 1)
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0011'
  AND lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0082'
  AND lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0114'
  AND lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0161'
  AND lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0258'
  AND lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0260'
  AND lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0263'
  AND lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0003'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0188'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0190'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0191'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0232'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0244'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0249'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0267'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0273'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0275'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0281'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0284'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0292'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0298'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0339'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0346'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0381'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0384'
  AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0258'
  AND lower(g.name_en) = lower('ESPRESSO FREE') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0259'
  AND lower(g.name_en) = lower('ESPRESSO FREE') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0260'
  AND lower(g.name_en) = lower('ESPRESSO FREE') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0261'
  AND lower(g.name_en) = lower('ESPRESSO FREE') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0262'
  AND lower(g.name_en) = lower('ESPRESSO FREE') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0221'
  AND lower(g.name_en) = lower('PATCH 4L') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, (SELECT o.id FROM public.modifier_options o WHERE o.sku = 'sk-0348' LIMIT 1)
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0142'
  AND lower(g.name_en) = lower('COFFEE DAY BOX') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0004'
  AND lower(g.name_en) = lower('TEMP') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0005'
  AND lower(g.name_en) = lower('TEMP') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0007'
  AND lower(g.name_en) = lower('TEMP') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0008'
  AND lower(g.name_en) = lower('TEMP') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0233'
  AND lower(g.name_en) = lower('ESPRESSO PLUS') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0188'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0190'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0191'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0232'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0244'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0249'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0267'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0273'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0275'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0281'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0284'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0292'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0298'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0339'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 2, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0346'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0381'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0384'
  AND lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0004'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0005'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0006'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0007'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 0, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0008'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0009'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0010'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0011'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0012'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0114'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0161'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0264'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 1, 1, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0377'
  AND lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 4, 4, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0349'
  AND lower(g.name_en) = lower('The Best Seller Group') AND g.name_ar = 'المجموعة الاكثر مبيعاً'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 5, 5, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0350'
  AND lower(g.name_en) = lower('The Four Beans Group') AND g.name_ar = 'مجموعة الاربع محاصيل'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 3, 3, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0351'
  AND lower(g.name_en) = lower('Ice Drip Group') AND g.name_ar = 'مجموعة الايس دريب'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 3, 3, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0352'
  AND lower(g.name_en) = lower('Classic Group') AND g.name_ar = 'المجموعة الكلاسيكية'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

INSERT INTO public.item_modifier_groups (item_id, group_id, min_select, max_select, default_option_id)
SELECT i.id, g.id, 4, 4, NULL
FROM public.menu_items i, public.modifier_groups g
WHERE i.sku = 'sk-0353'
  AND lower(g.name_en) = lower('Drip Envelopes Group 15') AND g.name_ar = 'مجموعة اظرف القهوة المختصة'
ON CONFLICT (item_id, group_id) DO UPDATE
  SET min_select = EXCLUDED.min_select, max_select = EXCLUDED.max_select,
      default_option_id = EXCLUDED.default_option_id;

-- Verify: SELECT count(*) FROM public.item_modifier_groups;  -- expect ~93
