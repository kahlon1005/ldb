
--Forcast replen cases 

;with fullPalByOrdSku as (
SELECT od.whse_code, 
		od.sku, 
		sum(IIF(od.ob_lno_stt IN ('HOLD','BLD','IHLD','IPLN','SPLN','SSPL','SSRL'), floor(od.plan_qty/pm.qty1in2/(pm.custom_numeric_1 * pm.custom_numeric_2)), 0)) as ord_pal_unplanned,
		sum(IIF(od.ob_lno_stt IN ('PLN','RDY','IRLS','SRLS','SUSP'), floor(od.plan_qty/qty1in2/(pm.custom_numeric_1 * pm.custom_numeric_2)), 0)) as ord_pal_planned
	FROM od_f od 
		inner join pm_f pm on od.whse_code = pm.whse_code and od.sku = pm.sku
	GROUP BY od.whse_code, od.sku, od.ob_oid),
fullPalBySku as (
	select 
		whse_code, 
		sku, 
		sum(ord_pal_unplanned) as sku_pal_unplanned, 
		sum(ord_pal_planned) as sku_pal_planned
	from fullPalByOrdSku
	group by whse_code, sku
) 
SELECT --836 rows
  a.whse_code,
  a.sku, 
  a.sku_desc, 
  a.fp_repl_uom, --replen UOM of the FP locations of the item, e.g. BTL, CASE12, PALLET. If there are multiple repl_uom, the highest one is used.
  a.fp_repl_uom_qty, --BTL qty of the replen UOM, e.g. 12 if repl_uom = CASE12
  repl_dynam_qty_sum, --sum of dynamic replen qty of all FP locations of the item
  fpQty.fp_iv/fp_repl_uom_qty as [FP Quantity (Cases)],
  ord_qty_unplanned/fp_repl_uom_qty AS plan_qty_to_plan, --total plan_qty of the item in all sales orders that are not planned, in repl_uom.
  bld_qty/fp_repl_uom_qty AS [Build Quantity (Cases)],
  (ISNULL(ord_qty_planned,0)-ISNULL(qty_cm_non_fp,0)-ISNULL(qty_picked,0))/fp_repl_uom_qty AS plan_qty_planned, --total plan_qty of the item in all sales orders that are planned but not picked, in repl_uom.
  (ISNULL(ord_qty_unplanned,0)+ISNULL(ord_qty_planned,0)-ISNULL(qty_cm_non_fp,0)-ISNULL(qty_picked,0))/fp_repl_uom_qty AS plan_qty_total, --total plan_qty of the item in all sales orders that are not picked, in repl_uom.
  ord_qty_unplanned/fp_repl_uom_qty/repl_dynam_qty_sum AS repl_count_to_plan, --total replen count of the item in all sales orders that are not planned.
  (ISNULL(ord_qty_planned,0)-ISNULL(qty_cm_non_fp,0)-ISNULL(qty_picked,0))/fp_repl_uom_qty/repl_dynam_qty_sum AS repl_count_planned, --total replen count of the item in all sales orders that are planned but not picked.
  (ISNULL(ord_qty_unplanned,0)+ISNULL(ord_qty_planned,0)-ISNULL(qty_cm_non_fp,0)-ISNULL(qty_picked,0))/fp_repl_uom_qty/repl_dynam_qty_sum AS repl_count_total, --total replen count of the item in all sales orders that are not picked.
  --fps.sku_pal_planned as [Plan Full Pallet Allocation], --fps.sku_pal_planned
  --fps.sku_pal_unplanned as [Unplan Full Pallet Allocation], --fps.sku_pal_unplanned
  isnull(recv_iv/fp_repl_uom_qty, 0) AS recv_iv, --total qty of current FIFO inventory of the item, in repl_uom.
  isnull(fifo_iv/fp_repl_uom_qty, 0) AS fifo_iv,  --total qty of current RECV inventory of the item, in repl_uom.
  isnull(Replns.replnCount, 0) as[Planned Replenishments]
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
			WHERE loc_type='FP' AND area IN ('APCK','SCAGE','SCAGEP') GROUP BY whse_code, sku) lc ON pm.whse_code=lc.whse_code AND pm.sku=lc.sku 
		LEFT JOIN (
			SELECT iv.whse_code, 
				iv.sku, 
				sum(IIF(lc.loc_type='RECV', qty, 0)) as recv_iv,
				sum(IIF(lc.loc_type='FIFO', qty, 0)) as fifo_iv
			FROM iv_f iv 
				INNER JOIN lc_f lc ON iv.loc=lc.loc 
			WHERE lc.loc_type='RECV' AND area IN ('APCK','SCAGE','SCAGEP')
			GROUP BY iv.whse_code, iv.sku) iv1 ON pm.whse_code=iv1.whse_code AND pm.sku=iv1.sku
  ) a
  LEFT JOIN --unplanned qty in UOM1 
    (SELECT od.whse_code, 
		od.sku, 
		sum(IIF(od.ob_lno_stt IN ('HOLD','BLD','IHLD','IPLN','SPLN','SSPL','SSRL'), od.plan_qty, 0)) as ord_qty_unplanned,
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
	WHERE lc.loc_type!='FP' AND cm.task_code='PICK' AND cm.to_cont IS NOT NULL AND LEN(cm.to_cont)>0 AND od.ob_lno_stt IN ('PLN','RDY','IRLS','SRLS','SUSP') AND lc.area IN ('APCK','SCAGE','SCAGEP')
	GROUP BY cm.whse_code, cm.sku
	) e ON e.whse_code=a.whse_code AND e.sku=a.sku
  LEFT JOIN --picked qty in UOM1 
    (SELECT it.whse_code, it.sku, SUM(it.act_qty) AS qty_picked 
	FROM it_f it 
	  INNER JOIN lc_f lc ON lc.whse_code=it.whse_code AND lc.loc=it.from_loc
	  INNER JOIN od_f od ON od.whse_code=it.whse_code AND od.ob_oid=it.ob_oid AND od.ob_lno=it.ob_lno
	  WHERE it.transact='RPCK' AND lc.loc_type IN ('FP','FIFO') AND od.ob_lno_stt IN ('PLN','RDY','IRLS','SRLS','SUSP','HOLD','BLD','IHLD','IPLN','SPLN','SSPL','SSRL') AND area IN ('APCK','SCAGE','SCAGEP')
	  GROUP BY it.whse_code, it.sku
	) f ON f.whse_code=a.whse_code AND f.sku=a.sku
  LEFT JOIN ( 
	select cm_f.whse_code, cm_f.sku, count(0) as replnCount 
	from cm_f 
	inner join lc_F on lc_f.whse_code = cm_f.whse_code and lc_f.loc = cm_f.loc
	where task_code = 'REPL'AND lc_f.area IN ('APCK','SCAGE','SCAGEP')
	group by cm_f.whse_code, cm_f.sku
  ) Replns on Replns.whse_code=a.whse_code AND Replns.sku=a.sku
  LEFT JOIN (
  select 
		iv.whse_code,
		iv.sku,
		sum(IIF(lc.loc_type='fp', qty, 0)) as fp_iv
	from iv_f iv
		INNER JOIN lc_f lc ON iv.loc=lc.loc 
	where lc.loc_type = 'FP' AND area IN ('APCK','SCAGE','SCAGEP')
	group by iv.sku, iv.whse_code
  ) fpQty on fpQty.whse_code=a.whse_code AND fpQty.sku=a.sku
  LEft join fullPalBySku fps on fps.whse_code=a.whse_code AND fps.sku=a.sku
  WHERE (ISNULL(ord_qty_unplanned,0)>0 OR ISNULL(ord_qty_planned,0)>0) 
  --and a.whse_code = 'VDC' 


	

	--select top 100 * from od_f

	--select top 100 *, custom_numeric_1, custom_numeric_1 from pm_f

	--SELECT od.whse_code, 
	--	od.sku, 
	--	sum(od.plan_qty),
	--	sum(IIF(od.ob_lno_stt IN ('HOLD','BLD','IHLD','IPLN','SPLN','SSPL','SSRL'), floor(od.plan_qty/pm.qty1in2/(pm.custom_numeric_1 * pm.custom_numeric_2)), 0)) as ord_pal_unplanned,
	--	sum(IIF(od.ob_lno_stt IN ('PLN','RDY','IRLS','SRLS','SUSP'), floor(od.plan_qty/qty1in2/(pm.custom_numeric_1 * pm.custom_numeric_2)), 0)) as ord_pal_planned
	--FROM od_f od 
	--	inner join pm_f pm on od.whse_code = pm.whse_code and od.sku = pm.sku
	--GROUP BY od.whse_code, od.sku, od.ob_oid