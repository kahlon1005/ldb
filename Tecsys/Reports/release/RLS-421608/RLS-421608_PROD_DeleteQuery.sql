--please run the delete query before running the MDTool Excel Macros

USE prod_94x_m  

--------------------
-- 1. wms_mobile_receiving_menu
--------------------
-- PROD#  11 rows
--select *
delete from md_resource_group where parent_resource_n = 'wms_mobile_receiving_menu'



