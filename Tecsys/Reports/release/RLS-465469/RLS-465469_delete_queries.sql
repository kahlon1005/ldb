--please run the delete queries before running the MDTool Excel Macros

USE prod_94x_m  

--------------------
-- 1. md_permission
--------------------
-- PROD#  8 rows
delete
from md_permission
where resource_name in ('wms_move.wf','wms_mobile_inventory_menu')
and role_name like '%picker%';

-- PROD#  38 rows
delete
from md_permission
where resource_name in 
(
'wms_basic_recv.wf','wms_basic_recv.desktop.wf','wms_lc_f_full_ldb','wms_pm_f_items_full_ldb',
'wms_rf_f.basic_recv_by_tag.wf','wms_rf_f.basic_recv_by_item.wf',
'wms_rf_f.basic_recv.desktop.wf','wms_rf_f.basic_recv.wf_ldb'
)
and role_name in ('wms_inv_ctrl_ldb','wms_inv_ctrl_staff_ldb');




