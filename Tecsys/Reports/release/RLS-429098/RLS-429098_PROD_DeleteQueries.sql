--please run the delete query before running the MDTool Excel Macro

USE prod_94x_m  

--------------------
-- 1. wms_shipping
--------------------
-- PROD#  14 rows
--SELECT COUNT(1)
DELETE FROM md_detail_usage WHERE view_name = 'wms_cm_f.store_tag.wf_ldb'
;



