-- Operations Scorecard, for a specified date.
-- The productivity numbers are in PPH (Pallet Per Hour), CPH (Cases Per Hour), or BPH (Bottles Per Hour).
DECLARE @date1 date = DATEADD(DAY, -32, GETDATE());
DECLARE @date2 date = DATEADD(DAY, -2, GETDATE());
SELECT dw.date, dw.whse_code warehouse, receipt_pph, putaway_pph, case_repl_pph, bottle_repl_cph, case_pick_cph, bottle_pick_bph, 
  total_orders, total_orders-orders_nodelay orders_delayed, shipped_cases, shipped_bottles, total_customers, customers_shorted
FROM
-- Date-Warehouse List:
  (SELECT date, whse_code FROM
    (SELECT TOP (DATEDIFF(DAY, @date1, @date2)+1) date=DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id)-1, @date1)
    FROM sys.all_objects a CROSS JOIN sys.all_objects b) dl
    JOIN so_f ON 1=1) dw
  LEFT JOIN
-- Receipt Productivity (PPH):
  (SELECT date0, whse_code, ROUND(SUM(sku_pallets)/(SUM(sku_sec)/3600.0),1,0) receipt_pph FROM 
    (SELECT date0, t1.whse_code, t1.sku, (CASE WHEN uom2='PALLET' THEN sku_qty/qty1in2 ELSE sku_qty/qty1in2/qty2in3 END) sku_pallets, sku_sec FROM
      (SELECT CONVERT(date,create_stamp) date0, whse_code, sku, SUM(act_qty) sku_qty, (SUM(DATEDIFF(SECOND,start_time,end_time))) sku_sec FROM it_f 
	  WHERE (transact='RCPT' AND from_loc LIKE '%RECV%') AND sku!='' AND CONVERT(date,create_stamp) BETWEEN @date1 AND @date2 
	  AND DATEDIFF(SECOND,start_time,end_time)>0 
	  GROUP BY CONVERT(date,create_stamp), whse_code, sku) t1
    JOIN pm_f pm ON t1.whse_code=pm.whse_code AND t1.sku=pm.sku) t2
  GROUP BY whse_code, date0) rp ON dw.date=rp.date0 AND dw.whse_code=rp.whse_code
  LEFT JOIN
-- Putaway Productivity (PPH):
  (SELECT date0, whse_code, ROUND(SUM(sku_pallets)/(SUM(sku_sec)/3600.0),1,0) putaway_pph FROM 
    (SELECT date0, t1.whse_code, t1.sku, (CASE WHEN uom2='PALLET' THEN sku_qty/qty1in2 ELSE sku_qty/qty1in2/qty2in3 END) sku_pallets, sku_sec FROM
      (SELECT CONVERT(date,create_stamp) date0, whse_code, sku, SUM(act_qty) sku_qty, (SUM(DATEDIFF(SECOND,start_time,end_time))) sku_sec FROM it_f 
	  WHERE (transact='STOR' AND from_loc LIKE '%RECV%') AND sku!='' AND CONVERT(date,create_stamp) BETWEEN @date1 AND @date2 
	  AND DATEDIFF(SECOND,start_time,end_time)>0 
	  GROUP BY CONVERT(date,create_stamp), whse_code, sku) t1
    JOIN pm_f pm ON t1.whse_code=pm.whse_code AND t1.sku=pm.sku) t2
  GROUP BY t2.whse_code, date0) pp ON dw.date=pp.date0 AND dw.whse_code=pp.whse_code
  LEFT JOIN
-- Case Replenishment Productivity (PPH):
  (SELECT date0, whse_code, ROUND(SUM(sku_pallets)/(SUM(sku_sec)/3600.0),1,0) case_repl_pph FROM 
    (SELECT date0, t1.whse_code, t1.sku, (CASE WHEN uom2='PALLET' THEN sku_qty/qty1in2 ELSE sku_qty/qty1in2/qty2in3 END) sku_pallets, sku_sec FROM
      (SELECT CONVERT(date,it.create_stamp) date0, it.whse_code, it.sku, SUM(act_qty) sku_qty, (SUM(DATEDIFF(SECOND,start_time,end_time))) sku_sec FROM it_f it 
	  JOIN lc_f lc ON it.whse_code=lc.whse_code AND it.to_loc=lc.loc
	  WHERE transact='REPL' AND it.sku!='' AND CONVERT(date,it.create_stamp) BETWEEN @date1 AND @date2 
	  AND lc.loc_type='FP' AND lc.area in ('APCK','ACAG','INVM') AND DATEDIFF(SECOND,start_time,end_time)>0 
	  GROUP BY CONVERT(date,it.create_stamp), it.whse_code, it.sku) t1
    JOIN pm_f pm ON t1.whse_code=pm.whse_code AND t1.sku=pm.sku) t2
  GROUP BY t2.whse_code, date0) crp ON dw.date=crp.date0 AND dw.whse_code=crp.whse_code
  LEFT JOIN
-- Bottle Replenishment Productivity (CPH):
  (SELECT date0, whse_code, ROUND(SUM(sku_cases)/(SUM(sku_sec)/3600.0),1,0) bottle_repl_cph FROM 
    (SELECT date0, t1.whse_code, t1.sku, (CASE WHEN uom1='BTL' THEN sku_qty/qty1in2 ELSE sku_qty END) sku_cases, sku_sec FROM
      (SELECT CONVERT(date,it.create_stamp) date0, it.whse_code, it.sku, SUM(act_qty) sku_qty, (SUM(DATEDIFF(SECOND,start_time,end_time))) sku_sec FROM it_f it 
      JOIN lc_f lc ON it.whse_code=lc.whse_code AND it.to_loc=lc.loc
	  WHERE transact='REPL' AND it.sku!='' AND CONVERT(date,it.create_stamp) BETWEEN @date1 AND @date2 
	  AND lc.loc_type='FP' AND lc.area in ('AB1R','AB2R','AB3L','AB3P','AB3T') AND DATEDIFF(SECOND,start_time,end_time)>0 
	  GROUP BY CONVERT(date,it.create_stamp), it.whse_code, it.sku) t1
    JOIN pm_f pm ON t1.whse_code=pm.whse_code AND t1.sku=pm.sku) t2
  GROUP BY t2.whse_code, date0) brp ON dw.date=brp.date0 AND dw.whse_code=brp.whse_code
  LEFT JOIN
-- Case Assembly Productivity (CPH):
  (SELECT date0, whse_code, ROUND(SUM(sku_cases)/(SUM(sku_sec)/3600.0),1,0) case_pick_cph FROM 
    (SELECT date0, t1.whse_code, t1.sku, (CASE WHEN uom1='BTL' THEN sku_qty/qty1in2 ELSE sku_qty END) sku_cases, sku_sec FROM
      (SELECT CONVERT(date,it.create_stamp) date0, it.whse_code, it.sku, SUM(act_qty) sku_qty, (SUM(DATEDIFF(SECOND,start_time,end_time))) sku_sec FROM it_f it 
      JOIN lc_f lc ON it.whse_code=lc.whse_code AND it.from_loc=lc.loc
      WHERE transact in ('RPCK','PICK') AND it.sku!='' AND act_qty>0 AND CONVERT(date,it.create_stamp) BETWEEN @date1 AND @date2 
	  AND lc.area in ('APCK','ACAG','INVM') AND lc.loc_type='FP' AND DATEDIFF(SECOND,start_time,end_time)>0 
	  GROUP BY CONVERT(date,it.create_stamp), it.whse_code, it.sku) t1
    JOIN pm_f pm ON t1.whse_code=pm.whse_code AND t1.sku=pm.sku) t2
  GROUP BY t2.whse_code, date0) cap ON dw.date=cap.date0 AND dw.whse_code=cap.whse_code
  LEFT JOIN
-- Bottle Assembly Productivity (BPH):
  (SELECT CONVERT(date,it.create_stamp) date0, it.whse_code, ROUND(SUM(act_qty)/(SUM(DATEDIFF(SECOND,start_time,end_time))/3600.0),1,0) bottle_pick_bph FROM it_f it 
  JOIN lc_f lc ON it.whse_code=lc.whse_code AND it.from_loc=lc.loc 
  WHERE transact in ('RPCK','PICK') AND it.sku!='' AND act_qty>0 AND CONVERT(date,it.create_stamp) BETWEEN @date1 AND @date2 
  AND lc.area in ('AB1R','AB2R','AB3L','AB3P','AB3T') AND lc.loc_type='FP' AND DATEDIFF(SECOND,start_time,end_time)>0 
  GROUP BY CONVERT(date,it.create_stamp), it.whse_code) bap ON dw.date=bap.date0 AND dw.whse_code=bap.whse_code
  LEFT JOIN
-- Total Outbound Orders:
  (SELECT CONVERT(date,ship_date) date0, whse_code, COUNT(1) total_orders FROM v_u_om_f 
  WHERE CONVERT(date,ship_date) BETWEEN @date1 AND @date2  
  GROUP BY whse_code, CONVERT(date,ship_date)) too ON dw.Date=too.date0 AND dw.whse_code=too.whse_code
  LEFT JOIN
-- Outbound Orders No-Delay:
  (SELECT CONVERT(date,om.ship_date) date0, c.whse_code, COUNT(1) orders_nodelay FROM 
    (SELECT whse_code, ob_oid, MAX(dtime_hist) ship_time FROM cp_h cp WHERE task_code='PICK' AND cont<>'' 
	AND NOT EXISTS (SELECT * FROM cm_f WHERE ob_oid=cp.ob_oid AND task_code='PICK') GROUP BY whse_code, ob_oid) c
    JOIN v_u_om_f om ON c.whse_code=om.whse_code AND c.ob_oid=om.ob_oid 
    WHERE CONVERT(date,om.ship_date) BETWEEN @date1 AND @date2 
    AND DATEDIFF(minute,ship_time,CONVERT(DATETIME,om.ship_date+' '+ISNULL(om.appoint_time,'0:0:0')))>0 
  GROUP BY c.whse_code, CONVERT(date,om.ship_date)) ond ON dw.date=ond.date0 AND dw.whse_code=ond.whse_code
  LEFT JOIN
-- Total Shipped Cases:
  (SELECT date0, whse_code, SUM(cases) shipped_cases FROM 
    (SELECT t1.date0, t1.whse_code, t1.ob_oid, (FLOOR((t1.qty)/ISNULL(pm.custom_numeric_3,1))) cases FROM
      (SELECT CONVERT(date,om.ship_date) date0, it.whse_code, it.ob_oid, it.sku, SUM(it.act_qty) qty FROM it_f it 
	  JOIN lc_f lc ON it.whse_code=lc.whse_code AND it.from_loc=lc.loc
	  JOIN v_u_om_f om ON it.whse_code=om.whse_code AND it.ob_oid=om.ob_oid
	  WHERE it.transact in ('RPCK','PICK') AND it.sku!='' AND it.act_qty>0 
	  AND lc.area in ('APCK','ACAG','INVM') AND lc.loc_type='FP' AND CONVERT(date,om.ship_date) BETWEEN @date1 AND @date2
	  GROUP BY it.whse_code, it.ob_oid, it.sku, CONVERT(date,om.ship_date)) t1
    JOIN 
      (SELECT it.whse_code, it.ob_oid FROM it_f it 
      JOIN v_u_om_f om ON it.whse_code=om.whse_code AND it.ob_oid=om.ob_oid
      WHERE it.transact='SHIP' AND CONVERT(date,om.ship_date) BETWEEN @date1 AND @date2
      GROUP BY it.whse_code, it.ob_oid) t2 ON t1.whse_code=t2.whse_code AND t1.ob_oid=t2.ob_oid
    JOIN pm_f pm ON t1.whse_code=pm.whse_code AND t1.sku=pm.sku) t3
  GROUP BY whse_code, date0) tsc ON dw.date=tsc.date0 AND dw.whse_code=tsc.whse_code
  LEFT JOIN 
-- Total Shipped Bottles: 
  (SELECT date0, t1.whse_code, FLOOR(SUM(t1.qty)) shipped_bottles FROM 
    (SELECT CONVERT(date,om.ship_date) date0, it.whse_code, it.ob_oid, SUM(act_qty) qty FROM it_f it 
    JOIN lc_f lc ON it.whse_code=lc.whse_code AND it.from_loc=lc.loc
    JOIN v_u_om_f om ON it.whse_code=om.whse_code AND it.ob_oid=om.ob_oid 
    WHERE transact in ('RPCK','PICK') AND it.sku!='' AND act_qty>0 
    AND lc.area in ('AB1R','AB2R','AB3L','AB3P','AB3T') AND lc.loc_type='FP' AND CONVERT(date,om.ship_date) BETWEEN @date1 AND @date2
    GROUP BY it.whse_code, it.ob_oid, CONVERT(date,om.ship_date)) t1
  JOIN 
    (SELECT it.whse_code, it.ob_oid FROM it_f it 
    JOIN v_u_om_f om ON it.whse_code=om.whse_code AND it.ob_oid=om.ob_oid
    WHERE it.transact='SHIP' AND CONVERT(date,om.ship_date) BETWEEN @date1 AND @date2
    GROUP BY it.whse_code, it.ob_oid) t2 ON t1.whse_code=t2.whse_code AND t1.ob_oid=t2.ob_oid
  GROUP BY t1.whse_code, date0) tsb ON dw.date=tsb.date0 AND dw.whse_code=tsb.whse_code
  LEFT JOIN
-- Outbound Customers Shorted:
  (SELECT date0, whse_code, COUNT(1) customers_shorted FROM 
    (SELECT CONVERT(date,om.ship_date) date0, om.whse_code, om.ship_name FROM od_h od
    JOIN v_u_om_f om ON om.whse_code=od.whse_code AND om.ob_oid=od.ob_oid 
    WHERE ship_qty<ord_qty AND CONVERT(date,om.ship_date) BETWEEN @date1 AND @date2 
    GROUP BY om.whse_code, om.ship_name, CONVERT(date,om.ship_date)) ob
  GROUP BY whse_code, date0) ocs ON dw.date=ocs.date0 AND dw.whse_code=ocs.whse_code
  LEFT JOIN
-- Total Outbound Customers
  (SELECT date0, whse_code, COUNT(1) total_customers FROM 
    (SELECT CONVERT(date,om.ship_date) date0, whse_code, ship_name FROM v_u_om_f om 
    WHERE CONVERT(date,ship_date) BETWEEN @date1 AND @date2 
    GROUP BY whse_code, ship_name, CONVERT(date,om.ship_date)) ob
  GROUP BY whse_code, date0) toc ON dw.date=toc.date0 AND dw.whse_code=toc.whse_code
ORDER BY dw.whse_code DESC, dw.date;
