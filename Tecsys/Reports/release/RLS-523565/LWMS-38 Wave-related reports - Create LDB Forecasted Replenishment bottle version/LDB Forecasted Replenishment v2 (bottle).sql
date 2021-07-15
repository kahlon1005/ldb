
SELECT 
  a.whse_code,
  a.sku, 
  a.sku_desc, 
  a.fp_repl_uom, 
  fp_locs as [Forward Pick Location],
  max_fp_cap,
  repl_uom,
  ord_qty_unplanned/fp_repl_uom_qty AS plan_qty_to_plan,
  bld_qty AS [Build Quantity (Bottles)],
  (ISNULL(ord_qty_planned,0)-ISNULL(qty_cm_non_fp,0)-ISNULL(qty_picked,0))/fp_repl_uom_qty AS [Order Qty Planned Unpicked],
  (ISNULL(ord_qty_unplanned,0)+ISNULL(ord_qty_planned,0)) as [Order Qty Total],
  (ISNULL(ord_qty_unplanned,0)+ISNULL(ord_qty_planned,0)-ISNULL(qty_cm_non_fp,0)-ISNULL(qty_picked,0))/fp_repl_uom_qty/repl_dynam_qty_sum AS Dynamic_repl_total, 
  fpQty.fp_iv as [FP Quantity (Bottles)],
  isnull(fifo_iv/fp_repl_uom_qty, 0) AS fifo_iv,  --total qty of current RECV inventory of the item, in repl_uom.
  isnull(recv_iv/fp_repl_uom_qty, 0) AS recv_iv, --total qty of current FIFO inventory of the item, in repl_uom.
  isnull(Replns.replnCount, 0) as[Planned Replenishments],
  (ISNULL(ord_qty_unplanned,0)+ISNULL(ord_qty_planned,0)-ISNULL(qty_cm_non_fp,0))/fp_repl_uom_qty/repl_dynam_qty_sum AS repl_count_total 
FROM 
  (SELECT pm.whse_code, pm.sku, pm.sku_desc, 
    repl_dynam_qty_sum, -- total of dynamic repl qty of all FP locations of the item
	recv_iv, 
	fifo_iv, -- current inventory qty of the locations of RECV and FIFO.
    CASE WHEN uom2=repl_uom THEN uom2 WHEN uom1=repl_uom THEN uom1 ELSE uom3 END AS fp_repl_uom, --replenishment UOM
    CASE WHEN uom2=repl_uom THEN qty1in2 WHEN uom1=repl_uom THEN 1 ELSE qty1in2*qty2in3 END AS fp_repl_uom_qty --qty of repl_uom in UOM1
    FROM pm_f pm 
		INNER JOIN (SELECT MAX(pm_rid) AS pm_rid 
			FROM pm_f GROUP BY whse_code, sku) pm2 ON pm2.pm_rid=pm.pm_rid
		INNER JOIN (SELECT whse_code, sku, MAX(repl_uom) AS repl_uom, SUM(repl_dynam_qty) AS repl_dynam_qty_sum 
			FROM lc_f 
			WHERE loc_type='FP' AND area IN ('AB1R', 'AB2R', 'AB3L', 'AB3P', 'AB3T') GROUP BY whse_code, sku) lc ON pm.whse_code=lc.whse_code AND pm.sku=lc.sku 
		LEFT JOIN (
			SELECT iv.whse_code, 
				iv.sku, 
				sum(IIF(lc.loc_type='RECV', qty, 0)) as recv_iv,
				sum(IIF(lc.loc_type='FIFO', qty, 0)) as fifo_iv
			FROM iv_f iv 
				INNER JOIN lc_f lc ON iv.loc=lc.loc 
			WHERE lc.loc_type='RECV' AND area IN ('AB1R', 'AB2R', 'AB3L', 'AB3P', 'AB3T')
			GROUP BY iv.whse_code, iv.sku) iv1 ON pm.whse_code=iv1.whse_code AND pm.sku=iv1.sku
  ) a
  LEFT JOIN --unplanned qty in UOM1 
    (SELECT od.whse_code, 
		od.sku, 
		sum(IIF(od.ob_lno_stt IN ('HOLD','IHLD','IPLN','SPLN','SSPL','SSRL'), od.plan_qty, 0)) as ord_qty_unplanned,
		sum(IIF(od.ob_lno_stt IN ('PLN','RDY','IRLS','SRLS','SUSP'), od.plan_qty, 0)) as ord_qty_planned,
		sum(IIF(od.ob_lno_stt IN ('BLD'), od.plan_qty, 0)) as bld_qty
	FROM od_f od 
	GROUP BY od.whse_code, od.sku
	) c ON c.whse_code=a.whse_code AND c.sku=a.sku
  LEFT JOIN --non-FP cm qty in UOM1 
    (SELECT 
		cm.whse_code, 
		cm.sku, 
		SUM(cm.qty) AS qty_cm_non_fp 
	FROM cm_f cm
	  INNER JOIN lc_f lc ON lc.whse_code=cm.whse_code AND lc.loc=cm.loc 
	  INNER JOIN od_f od ON od.whse_code=cm.whse_code AND od.od_rid=cm.od_rid 
	WHERE lc.loc_type!='FP' AND cm.task_code='PICK' AND cm.to_cont IS NOT NULL AND LEN(cm.to_cont)>0 AND od.ob_lno_stt IN ('PLN','RDY','IRLS','SRLS','SUSP') AND lc.area IN ('AB1R', 'AB2R', 'AB3L', 'AB3P', 'AB3T')
	GROUP BY cm.whse_code, cm.sku
	) e ON e.whse_code=a.whse_code AND e.sku=a.sku

  LEFT JOIN 
	(SELECT it.whse_code, it.sku, SUM(it.act_qty) AS qty_picked 
	FROM it_f it 
	  INNER JOIN lc_f lc ON lc.whse_code=it.whse_code AND lc.loc=it.from_loc
	  INNER JOIN od_f od ON od.whse_code=it.whse_code AND od.ob_oid=it.ob_oid AND od.ob_lno=it.ob_lno
	  WHERE it.transact='RPCK' AND lc.loc_type IN ('FP','FIFO') AND od.ob_lno_stt IN ('PLN','RDY','IRLS','SRLS','SUSP','HOLD','BLD','IHLD','IPLN','SPLN','SSPL','SSRL') AND area IN ('AB1R', 'AB2R', 'AB3L', 'AB3P', 'AB3T')
	  GROUP BY it.whse_code, it.sku
	) f ON f.whse_code=a.whse_code AND f.sku=a.sku
  
  LEFT JOIN ( 
	select cm_f.whse_code, cm_f.sku, count(0) as replnCount 
	from cm_f 
	inner join lc_F on lc_f.whse_code = cm_f.whse_code and lc_f.loc = cm_f.loc
	where task_code = 'REPL' AND lc_f.area IN ('AB1R', 'AB2R', 'AB3L', 'AB3P', 'AB3T')
	group by cm_f.whse_code, cm_f.sku
  ) Replns on Replns.whse_code=a.whse_code AND Replns.sku=a.sku
  LEFT JOIN (
  select 
		iv.whse_code,
		iv.sku,
		sum(IIF(lc.loc_type='fp', qty, 0)) as fp_iv
	from iv_f iv
		INNER JOIN lc_f lc ON iv.loc=lc.loc 
	where lc.loc_type = 'FP' AND area IN ('AB1R', 'AB2R', 'AB3L', 'AB3P', 'AB3T')
	group by iv.sku, iv.whse_code
  ) fpQty on fpQty.whse_code=a.whse_code AND fpQty.sku=a.sku
  LEFT JOIN (
  select 
		whse_code,
		sku,
		cast(STUFF((	SELECT N'; ' + loc 
				FROM lc_f AS p2
				WHERE lc_f.sku = p2.sku and lc_f.whse_code = p2.whse_code and p2.area IN ('AB1R', 'AB2R', 'AB3L', 'AB3P', 'AB3T')
				FOR XML PATH(N'')), 1, 2, N'')as nvarchar(1000)) as fp_locs,
		max(max_fp_cap) as max_fp_cap,
		max(repl_uom) as repl_uom
	from 
		lc_F 
	where 
		area IN ('AB1R', 'AB2R', 'AB3L', 'AB3P', 'AB3T')
		and sku != ''
	group by 
		sku, whse_code
	) fp_loc on fp_loc.whse_code=a.whse_code AND fp_loc.sku=a.sku
	WHERE 
		(ISNULL(ord_qty_unplanned,0)>0 OR ISNULL(ord_qty_planned,0)>0) 
		--and a.whse_code = 'VDC'



