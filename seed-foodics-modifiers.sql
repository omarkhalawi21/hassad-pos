-- ============================================================
-- SEED: real modifiers imported from the Foodics exports
-- (263649, 2026-07-16). Idempotent: groups by exact name pair,
-- options by SKU. Assignments seeded for the obvious cases
-- (Hot-or-Iced -> Coffee of the Day; MILK/TEMP/EXTRA SHOT -> milk
-- drinks); adjust per item in Menu -> Edit item.
-- ============================================================

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Drip Envelopes Group 15', 'مجموعة اظرف القهوة المختصة', NULL, false, 10, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Drip Envelopes Group 15') AND name_ar = 'مجموعة اظرف القهوة المختصة');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Classic Group', 'المجموعة الكلاسيكية', NULL, false, 20, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Classic Group') AND name_ar = 'المجموعة الكلاسيكية');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Ice Drip Group', 'مجموعة الايس دريب', NULL, false, 30, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Ice Drip Group') AND name_ar = 'مجموعة الايس دريب');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'The Four Beans Group', 'مجموعة الاربع محاصيل', NULL, false, 40, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('The Four Beans Group') AND name_ar = 'مجموعة الاربع محاصيل');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'The Best Seller Group', 'المجموعة الاكثر مبيعاً', 'offerbox', false, 50, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('The Best Seller Group') AND name_ar = 'المجموعة الاكثر مبيعاً');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'ESPRESSO', '', NULL, false, 60, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('ESPRESSO') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'V60 Extra Grams', '', NULL, false, 70, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('V60 Extra Grams') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'ESPRESSO PLUS', '', NULL, false, 80, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('ESPRESSO PLUS') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'TEMP', '', NULL, false, 90, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('TEMP') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'COFFEE DAY BOX', '', 'box', false, 100, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('COFFEE DAY BOX') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'PATCH 4L', '', 'patch', false, 110, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('PATCH 4L') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'ESPRESSO FREE', '', NULL, false, 120, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('ESPRESSO FREE') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Hot or Iced', 'حار او بارد', NULL, true, 130, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Hot or Iced') AND name_ar = 'حار او بارد');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'حار-Hot', 'حار-Hot', NULL, false, 140, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('حار-Hot') AND name_ar = 'حار-Hot');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Cup', 'الكوب', NULL, false, 150, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Cup') AND name_ar = 'الكوب');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'MILK', '', NULL, false, 160, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('MILK') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Beans', 'البن', NULL, false, 170, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Beans') AND name_ar = 'البن');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Colombia Manos', 'كولمبيا مانوس', NULL, false, 180, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Colombia Manos') AND name_ar = 'كولمبيا مانوس');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Low Fat Milk', '', NULL, false, 190, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Low Fat Milk') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'Extra Hot', '', NULL, false, 200, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('Extra Hot') AND name_ar = '');

INSERT INTO public.modifier_groups (name_en, name_ar, reference, required, sort_order, active)
SELECT 'EXTRA SHOT', '', NULL, false, 210, true
WHERE NOT EXISTS (SELECT 1 FROM public.modifier_groups WHERE lower(name_en) = lower('EXTRA SHOT') AND name_ar = '');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, '5 CUPS (9OZ)', '', 0.00, 'sk-0374', 10, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Classic Group') AND g.name_ar = 'المجموعة الكلاسيكية'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0374');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, '5 CUPS (9OZ)', '', 0.00, 'sk-0373', 20, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Ice Drip Group') AND g.name_ar = 'مجموعة الايس دريب'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0373');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, '5 CUPS (9OZ)', '', 0.00, 'sk-0372', 30, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Four Beans Group') AND g.name_ar = 'مجموعة الاربع محاصيل'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0372');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, '5 CUPS (9OZ)', '', 0.00, 'sk-0371', 40, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Best Seller Group') AND g.name_ar = 'المجموعة الاكثر مبيعاً'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0371');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, '15 CUPS(9OZ)', '', 0.00, 'sk-0370', 50, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Drip Envelopes Group 15') AND g.name_ar = 'مجموعة اظرف القهوة المختصة'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0370');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA DRIP BAG(5)', '', 0.00, 'sk-0369', 60, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Drip Envelopes Group 15') AND g.name_ar = 'مجموعة اظرف القهوة المختصة'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0369');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA DRIP BAG(5)', '', 0.00, 'sk-0368', 70, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Drip Envelopes Group 15') AND g.name_ar = 'مجموعة اظرف القهوة المختصة'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0368');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'BRAZIL DRIP BAG(5)', '', 0.00, 'sk-0367', 80, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Drip Envelopes Group 15') AND g.name_ar = 'مجموعة اظرف القهوة المختصة'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0367');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'OROMIO', '', 0.00, 'sk-0366', 90, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Classic Group') AND g.name_ar = 'المجموعة الكلاسيكية'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0366');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'BRAZIL FAZINDA', '', 0.00, 'sk-0365', 100, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Classic Group') AND g.name_ar = 'المجموعة الكلاسيكية'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0365');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA GUJI', '', 0.00, 'sk-0364', 110, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Ice Drip Group') AND g.name_ar = 'مجموعة الايس دريب'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0364');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA MANOS', '', 0.00, 'sk-0363', 120, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Ice Drip Group') AND g.name_ar = 'مجموعة الايس دريب'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0363');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA GUJI', '', 0.00, 'sk-0362', 130, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Four Beans Group') AND g.name_ar = 'مجموعة الاربع محاصيل'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0362');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'BRAZIL FAZINDA', '', 0.00, 'sk-0361', 140, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Four Beans Group') AND g.name_ar = 'مجموعة الاربع محاصيل'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0361');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'OROMIO', '', 0.00, 'sk-0360', 150, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Four Beans Group') AND g.name_ar = 'مجموعة الاربع محاصيل'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0360');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA MANOS', '', 0.00, 'sk-0359', 160, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Four Beans Group') AND g.name_ar = 'مجموعة الاربع محاصيل'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0359');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'BRAZIL FAZINDA', '', 0.00, 'sk-0358', 170, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Best Seller Group') AND g.name_ar = 'المجموعة الاكثر مبيعاً'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0358');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA MANOS', '', 0.00, 'sk-0357', 180, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Best Seller Group') AND g.name_ar = 'المجموعة الاكثر مبيعاً'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0357');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'OROMIO', '', 0.00, 'sk-0356', 190, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('The Best Seller Group') AND g.name_ar = 'المجموعة الاكثر مبيعاً'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0356');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA GUJI', '', 0.00, 'sk-0348', 200, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('COFFEE DAY BOX') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0348');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA GUJI', 'قوجي اثيوبيا', 8.00, 'sk-0342', 210, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('ESPRESSO PLUS') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0342');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHOPIA GUJI', 'قوجي اثيوبيا', 0.00, 'sk-0341', 220, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0341');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'SHAKISO', '', 0.00, 'sk-0335', 230, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('COFFEE DAY BOX') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0335');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA NARINO', '', 0.00, 'sk-0303', 240, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('COFFEE DAY BOX') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0303');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA OROMIO', 'اروميو', 0.00, 'sk-0302', 250, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('PATCH 4L') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0302');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA NARINO', '', 0.00, 'sk-0301', 260, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0301');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA GUJI', 'قوجي اثيوبيا', 0.00, 'sk-0300', 270, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('ESPRESSO') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0300');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA SHAKISO', 'شاكيسو', 0.00, 'sk-0299', 280, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('ESPRESSO FREE') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0299');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'FLOR', '', 0.00, 'sk-0295', 290, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('PATCH 4L') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0295');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'SHAKISO', '', 0.00, 'sk-0294', 300, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('PATCH 4L') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0294');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'hot', 'حار', 0.00, 'sk-0293', 310, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0293');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Ethiopia Shakiso', 'شاكيسو', 8.00, 'sk-0285', 320, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('ESPRESSO PLUS') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0285');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA OROMIO', 'اروميو', 0.00, 'sk-0253', 330, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('COFFEE DAY BOX') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0253');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'MANOS', '', 0.00, 'sk-0251', 340, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('PATCH 4L') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0251');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'GUJI', '', 0.00, 'sk-0250', 350, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('PATCH 4L') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0250');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Extra 5g', '', 2.00, 'sk-0248', 360, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('V60 Extra Grams') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0248');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA NARINO', '', 8.00, 'sk-0235', 370, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('ESPRESSO PLUS') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0235');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'STANDARD TEMP', 'حرارة معتدلة', 0.00, 'sk-0231', 380, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('TEMP') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0231');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'EXTRA HOT', 'حار جداً', 0.00, 'sk-0230', 390, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('TEMP') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0230');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'NARINO', '', 0.00, 'sk-0223', 400, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('PATCH 4L') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0223');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'BRAZIL', '', 0.00, 'sk-0222', 410, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('PATCH 4L') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0222');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Black Sheep', 'بلاك شيب', 4.00, 'sk-0219', 420, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0219');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA NARINO', 'كولومبيا نارينو', 0.00, 'sk-0216', 430, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('ESPRESSO FREE') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0216');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COLOMBIA HUILA', 'كولومبيا هويلا', 0.00, 'sk-0185', 440, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0185');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'GRAPE SODA', '', 8.00, 'sk-0178', 450, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0178');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ETHIOPIA BANKO', 'أثيوبي بانكو', 0.00, 'sk-0173', 460, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0173');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'SKIMMED', '', 0.00, 'sk-0168', 470, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('MILK') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0168');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'COCONUT', '', 2.00, 'sk-0167', 480, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('MILK') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0167');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ALMOND', '', 2.00, 'sk-0166', 490, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('MILK') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0166');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'FULL FAT', '', 0.00, 'sk-0165', 500, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('MILK') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0165');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'LOW FAT', '', 0.00, 'sk-0164', 510, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('MILK') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0164');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'FREE lactose', '', 1.00, 'sk-0163', 520, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('MILK') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0163');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Yemen Hiraz', 'اليمن حراز', 4.00, 'sk-0162', 530, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0162');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Costarica Directo', 'كوستاريكا دايركتو', 0.00, 'sk-0158', 540, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0158');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Colombia Manos', 'كولمبيا مانوس', 0.00, 'sk-0155', 550, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0155');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Narino Colombia', 'كولومبيا نارينو', 0.00, 'sk-0150', 560, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0150');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Colombia Witch', 'كولومبيا ويتش', 0.00, 'sk-0140', 570, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0140');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Kiboko', 'رواندا', 0.00, 'sk-0139', 580, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0139');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'برازيل-Brazil', 'برازيل-Brazil', 0.00, 'sk-0138', 590, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0138');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'ice', 'بارد', 0.00, 'sk-0134', 600, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0134');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'حار-Hot', 'حار-Hot', 0.00, 'sk-0133', 610, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('حار-Hot') AND g.name_ar = 'حار-Hot'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0133');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Paper', 'ورق', 0.00, 'sk-0113', 620, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0113');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Plastic', 'بلاستيك', 0.00, 'sk-0112', 630, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Cup') AND g.name_ar = 'الكوب'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0112');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Yemen, Mocha', 'اليمن، موكا', 0.00, 'sk-0081', 640, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0081');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Costarica, Asoproaa', 'كوستاريكا, اسوبروا', 0.00, 'sk-0078', 650, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0078');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Panma', 'بنما', 4.00, 'sk-0077', 660, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0077');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Ethiopia Bombe', 'إثيوبيا بومبي', 0.00, 'sk-0076', 670, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0076');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Costarica, Solis', 'كوستاريكا, سوليس', 0.00, 'sk-0075', 680, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Beans') AND g.name_ar = 'البن'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0075');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Colombia Manos', '', 0.00, 'sk-0067', 690, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Colombia Manos') AND g.name_ar = 'كولمبيا مانوس'
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0067');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Milk Option', '', 0.00, 'sk-0066', 700, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Extra Hot') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0066');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'Milk Option', '', 0.00, 'sk-0065', 710, false
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('Low Fat Milk') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0065');

INSERT INTO public.modifier_options (group_id, name_en, name_ar, price_delta, sku, sort_order, active)
SELECT g.id, 'EXTRA SHOT', '', 6.00, 'sk-0035', 720, true
FROM public.modifier_groups g WHERE lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
AND NOT EXISTS (SELECT 1 FROM public.modifier_options WHERE sku = 'sk-0035');

INSERT INTO public.item_modifier_groups (item_id, group_id)
SELECT i.id, g.id FROM public.menu_items i, public.modifier_groups g
WHERE i.sku IN ('sk-0003','sk-0263','sk-0313','sk-0221') AND lower(g.name_en) = lower('Hot or Iced') AND g.name_ar = 'حار او بارد'
ON CONFLICT DO NOTHING;

INSERT INTO public.item_modifier_groups (item_id, group_id)
SELECT i.id, g.id FROM public.menu_items i, public.modifier_groups g
WHERE i.sku IN ('sk-0004','sk-0005','sk-0007','sk-0008','sk-0010','sk-0161','sk-0082','sk-0233','sk-0262','sk-0311') AND lower(g.name_en) = lower('MILK') AND g.name_ar = ''
ON CONFLICT DO NOTHING;

INSERT INTO public.item_modifier_groups (item_id, group_id)
SELECT i.id, g.id FROM public.menu_items i, public.modifier_groups g
WHERE i.sku IN ('sk-0004','sk-0005','sk-0007','sk-0008','sk-0010','sk-0161','sk-0082','sk-0233','sk-0262','sk-0311') AND lower(g.name_en) = lower('TEMP') AND g.name_ar = ''
ON CONFLICT DO NOTHING;

INSERT INTO public.item_modifier_groups (item_id, group_id)
SELECT i.id, g.id FROM public.menu_items i, public.modifier_groups g
WHERE i.sku IN ('sk-0004','sk-0005','sk-0007','sk-0008','sk-0010','sk-0161','sk-0082','sk-0233','sk-0262','sk-0311') AND lower(g.name_en) = lower('EXTRA SHOT') AND g.name_ar = ''
ON CONFLICT DO NOTHING;
