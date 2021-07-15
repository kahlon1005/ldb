--Tecsys - SqlServer
------------------------
select iv_f.sku, pm_f.sku_desc, SUM(iv_f.qty) qty
from iv_f
inner join pm_f ON pm_f.whse_code = iv_f.whse_code AND pm_f.sku = iv_f.sku AND pm_f.pkg = iv_f.pkg
where loc <> '' 
--and sku = '399865'
GROUP BY iv_f.sku, pm_f.sku_desc;



--Ebuiness- Oracle 
---------------------
select SKU, DESCRIPTION, WAREHOUSE, AVAILABLE_QTY, HELD_QTY,RESERVED_QTY, AVAILABLE_QTY + HELD_QTY + RESERVED_QTY TOTAL_QTY, BTL_TO_PACK from apps.XX_ITEM_INV_QTY_DTL 
where warehouse = 'VDC' 
  and sku = '00399865'


--iStore - wsinv postgreSQL
-----------------------------
select sku, available_single_units, reserved_single_units, hold_single_units, expected_single_units from wsinv.inv_ldbdc 
where dc = 'VDC'
--and sku = '399865'
