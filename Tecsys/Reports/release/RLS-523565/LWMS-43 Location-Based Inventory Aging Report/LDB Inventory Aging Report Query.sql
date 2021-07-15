-- 2019-11-25
SELECT lc.whse_code "Warehouse", lc.loc "Location", lc.sku "SKU", 
DATEDIFF(DAY, it1.dt_recv, CURRENT_TIMESTAMP) "First Receipt (days ago)", 
DATEDIFF(DAY, it2.end_time, CURRENT_TIMESTAMP) "Last Movement (days ago)", 
iv.qty "Current Quantity", iv.alloc_qty "Allocated Quantity", iv.intran_qty "In-Transit Quantity", 
sz.zone_code "Zone", sz.desc_1 "Zone Description", 
lc.loc_type "Location Type", lc.search "Forward Pick Search Path", lc.max_fp_cap "Maximum FP Location Capacity", 
lc.repl_uom "Replenishment UOM", lc.repl_dynam_qty "Dynamic Replenishment Quantity", lc.repl_batch_qty "Batch Replenishment Quantity", 
lc.trig_uom "Trigger Point UOM", lc.trig_dynam_qty "Dynamic Trigger Quantity", lc.trig_batch_qty "Batch Trigger Quantity", 
lc.whse_section "Section", lc.area "Area", lc.route_point "Route Point", 
lc.cycc_stat "Cycle Count Status", lc.loc_stt "Location Status", lc.empty "Empty", lc.tag_track "Tag Tracking", lc.eq_class "Location Class", 
lc.wgt "Weight", lc.hgt "Height", lc.wid "Width", lc.dpth "Depth", lc.cmd_seq "Command Sequence", lc.store_seq "Storage Sequence",
CASE WHEN lc.area='APCK' THEN 'PALLET' ELSE 'CASE' END "Item UOM",
CASE WHEN lc.area='APCK' THEN CASE WHEN pm.uom2='PALLET' THEN pm.wgt2 ELSE pm.wgt3 END ELSE CASE WHEN pm.uom1='BTL' THEN pm.wgt2 ELSE pm.wgt1 END END "Item Weight",
CASE WHEN lc.area='APCK' THEN CASE WHEN pm.uom2='PALLET' THEN pm.hgt2 ELSE pm.hgt3 END ELSE CASE WHEN pm.uom1='BTL' THEN pm.hgt2 ELSE pm.hgt1 END END "Item Height",
CASE WHEN lc.area='APCK' THEN CASE WHEN pm.uom2='PALLET' THEN pm.wid2 ELSE pm.wid3 END ELSE CASE WHEN pm.uom1='BTL' THEN pm.wid2 ELSE pm.wid1 END END "Item Width",
CASE WHEN lc.area='APCK' THEN CASE WHEN pm.uom2='PALLET' THEN pm.dpth2 ELSE pm.dpth3 END ELSE CASE WHEN pm.uom1='BTL' THEN pm.dpth2 ELSE pm.dpth1 END END "Item Depth",
CASE WHEN lc.area='APCK' THEN CASE WHEN pm.uom2='PALLET' THEN pm.hgt2*pm.wid2*pm.dpth2 ELSE pm.hgt3*pm.wid3*pm.dpth3 END ELSE CASE WHEN pm.uom1='BTL' THEN pm.hgt2*pm.wid2*pm.dpth2 ELSE pm.hgt1*pm.wid1*pm.dpth1 END END "Item Volumn",
CASE WHEN pm.uom2='PALLET' THEN pm.qty1in2 ELSE pm.qty2in3 END "Item Cases Per Pallet",
pm.inv_class "Item Inventory Class",
pm.custom_char_2 "Item Listing Type",
pm.custom_char_4 "Item Custom Char 4"
FROM lc_f lc
JOIN storage_zone sz ON lc.whse_code=sz.whse_code AND lc.zone=sz.zone_code 
JOIN pm_f pm ON lc.whse_code=pm.whse_code AND lc.sku=pm.sku 
LEFT JOIN (SELECT whse_code, loc, sku, SUM(qty)qty, SUM(alloc_qty)alloc_qty, SUM(intran_qty)intran_qty 
  FROM iv_f WHERE hold='' GROUP BY whse_code, loc, sku) iv ON iv.whse_code=lc.whse_code AND iv.loc=lc.loc 
LEFT JOIN 
  (SELECT t1.whse_code, t1.it_rid, t1.dt_recv, t1.sku FROM it_f t1 INNER JOIN 
    (SELECT whse_code, MIN(it_rid)"min_rid" FROM it_f WHERE transact='RCPT' AND sku!='' AND act_qty>0 GROUP BY whse_code, sku) t2 
    ON t1.it_rid=t2.min_rid AND t1.whse_code=t2.whse_code) it1
  ON it1.whse_code=iv.whse_code AND it1.sku=iv.sku 
LEFT JOIN 
  (SELECT t1.whse_code, t1.it_rid, t1.end_time, t1.from_loc, t1.sku FROM it_f t1 INNER JOIN 
    (SELECT whse_code, MAX(it_rid)"max_rid" FROM it_f WHERE transact='RPCK' AND sku!='' GROUP BY whse_code, from_loc) t2 
    ON t1.it_rid=t2.max_rid AND t1.whse_code=t2.whse_code) it2
  ON it2.whse_code=iv.whse_code AND it2.from_loc=iv.loc AND it2.sku=iv.sku 
WHERE lc.loc_type='FP' AND lc.host_availability_hold='' 
ORDER BY lc.whse_code, zone_code
