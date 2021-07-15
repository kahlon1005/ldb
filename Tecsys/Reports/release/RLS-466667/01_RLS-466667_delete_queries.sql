--please run the delete queries before running the MDTool Excel Macros

USE prod_94x_m  
;
--------------------
-- 1. md_permission
--------------------
-- PROD#  8 rows
--select *
delete
from md_permission
where role_name = 'wms_locations_full_access_ldb'
;
--------------------
-- 2. md_permission
--------------------
-- PROD#  5 rows
--select *
delete
from md_permission
where role_name = 'wms_basic_receiving_ldb'
and resource_name = 'wms_pm_f_items_full_ldb'
;
--------------------
-- 3. md_role
--------------------
-- PROD#  1 row
--select *
delete
from md_role
where role_name = 'wms_locations_full_access_ldb'
;