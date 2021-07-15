DROP VIEW IF EXISTS [dbo].[v_ob_ord_stt_summ_ldb];
GO

CREATE VIEW [dbo].[v_ob_ord_stt_summ_ldb]
AS
SELECT
    v_u_om_f.om_rid,
	v_u_om_f.whse_code, 
	v_u_om_f.ob_type,
	v_u_om_f.ob_oid,
	cust_order = STUFF(
			(SELECT DISTINCT ', ' + cust_oid FROM v_u_od_f
			WHERE v_u_od_f.whse_code = v_u_om_f.whse_code
			  AND v_u_od_f.ob_oid = v_u_om_f.ob_oid
			FOR XML PATH('')), 1, 1, ''),	
	v_u_om_f.shipment,
	v_u_om_f.ship_custnum, 
	v_u_om_f.ship_name, 
	case when v_u_om_f.ob_ord_stt <> 'SHIP' then v_u_om_f.create_stamp else v_u_om_f.ship_date + v_u_om_f.appoint_time end as ord_datetime, 
	v_u_om_f.ship_date + v_u_om_f.appoint_time as ship_datetime, 
	v_u_om_f.carrier_service, v_u_om_f.ob_ord_stt	ob_ord_stt,
	ISNULL(FLOOR((SUM(v_u_od_f.cmp_qty + IIF(v_u_od_f.sched_qty < 0, v_u_od_f.sched_qty,0))/NULLIF(SUM(v_u_od_f.plan_qty),0))*100),0)  AS compl_pct,
	max(bol.create_stamp) as bol_date,
	case when v_u_om_f.ob_ord_stt = 'SHIP' then v_u_om_f.create_stamp else null end as ship_compl_datetime,
	v_u_om_f.wave
FROM v_u_om_f
full outer join bol_po on v_u_om_f.ob_oid = bol_po.ship_po and v_u_om_f.whse_code = bol_po.whse_code
full outer join bol on bol_po.bol_id = bol.bol_id and bol_po.whse_code = bol.whse_code
full outer join v_u_od_f on v_u_om_f.ob_oid = v_u_od_f.ob_oid and v_u_om_f.whse_code = v_u_od_f.whse_code
GROUP BY v_u_om_f.om_rid, v_u_om_f.whse_code, v_u_om_f.ob_type, v_u_om_f.ob_oid, v_u_om_f.custom_char_10, v_u_om_f.shipment, v_u_om_f.ship_custnum, 
v_u_om_f.ship_name, v_u_om_f.create_stamp, v_u_om_f.ship_date + v_u_om_f.appoint_time, 
v_u_om_f.carrier_service, v_u_om_f.ob_ord_stt, v_u_om_f.wave;
--order by v_u_om_f.ship_date + v_u_om_f.appoint_time asc

GO

