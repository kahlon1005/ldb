---
-- Check for Item difference between VDC and KDC
-- Expected Output: item_diff_count = 0
---
select count(*) as item_diff_count from (select sku from pm_f where whse_code = 'VDC' except select sku from pm_f where whse_code = 'KDC') as subquery;

---
-- Check for Item Aliases difference between VDC and KDC
-- Expected Output: item_aliases_diff_count = 0
---
select count(*) as Item_aliases_diff_count from (select sku, alias_sku from al_f where whse_code = 'VDC' except select  sku, alias_sku from al_f where whse_code = 'KDC') as subquery;

---
-- Check and confirm the volumetric changed flag is set to 0. If not update it to 0.
-- Expected Output: volumetric_change_count = 0
---
select count(*) as volumetric_change_count from pm_f where custom_numeric_10 = 1 and whse_code = 'KDC';
-- To update the volumetric flat to 0 if needed
--update pm_f SET custom_numeric_10 = 0 WHERE custom_numeric_10 = 1 and whse_code = 'KDC';

---
-- Check and confirm the storage rules are correct
-- Expected Output: wrong_regular_product_storage_rule, wrong_nswp_product_storage_rule, wrong_delisted_product_storage_rule = 0
---
--Check the regular product
select count(*) as wrong_regular_product_storage_rule from [dbo].[pm_f] where [store_rule] != 'SRSUPR' and custom_char_2 not like '%BO' and custom_char_1 != '4.2' and whse_code = 'KDC';
select count(*) as wrong_nswp_product_storage_rule from [dbo].[pm_f] where [store_rule] != 'SRNSWP' and custom_char_2 like '%BO' and custom_char_1 != '4.2' and whse_code = 'KDC';
select count(*) as wrong_delisted_product_storage_rule from [dbo].[pm_f] where [store_rule] != 'SRDELIST' and custom_char_1 = '4.2' and whse_code = 'KDC';
-- To recover, re-run the updated scripts from the inital load

---
-- Validate NSWP items are set to ready
---
select count(*) as nswp_not_in_rdy_status from [dbo].[pm_f] where [part_status] != 'RDY' and custom_char_2 LIKE '%BO' and whse_code = 'KDC';

---
-- Validate the default release putaway is configured correct
---
select count(*) as wrong_def_rel_put_for_reg_prod from [dbo].[pm_f] where [def_rel_put] = 'Y' and custom_char_2 NOT LIKE '%BO' and whse_code = 'KDC';
select count(*) as wrong_def_rel_put_for_nswp from [dbo].[pm_f] where [def_rel_put] = 'N' and custom_char_2 LIKE '%BO' and whse_code = 'KDC';

