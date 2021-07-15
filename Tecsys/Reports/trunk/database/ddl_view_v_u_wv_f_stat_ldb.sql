DROP VIEW IF EXISTS [dbo].[v_u_wv_f_stat_ldb];
GO

CREATE   VIEW [dbo].[v_u_wv_f_stat_ldb] 
AS
SELECT b.whse_code,
       b.wave,
       b.shipment, 
	   b.appoint_date_time_ldb, 
	   (SELECT MAX(it_f.create_stamp)
                    FROM   it_f
                    WHERE  b.whse_code = it_f.whse_code
                      AND  b.wave = it_f.wave
                      AND  it_f.transact = 'RDY') AS release_date_time_ldb,
       b.carrier_service, 
	   CAST(b.case_to_pick_sum AS INTEGER) AS case_to_pick_ldb, 
	   CAST(b.case_to_pick_sum + b.case_picked_sum AS INTEGER) AS case_to_be_picked_ldb, 
	   CAST(b.case_picked_sum AS INTEGER) AS case_picked_ldb, 
	   CAST(ROUND(CASE WHEN b.case_to_pick_sum + b.case_picked_sum = 0 THEN 100 ELSE ISNULL(b.case_picked_sum/(b.case_to_pick_sum + b.case_picked_sum)*100, 0) END,1) AS DECIMAL(4,1)) AS case_percent_complete_ldb, 
	   CAST(b.bottle_to_pick_sum AS INTEGER) AS bottle_to_pick_ldb, 
	   CAST(b.bottle_to_pick_sum + b.bottle_picked_sum AS INTEGER) AS bottle_to_be_picked_ldb, 
	   CAST(b.bottle_picked_sum AS INTEGER) AS bottle_picked_ldb, 
	   CAST(ROUND(CASE WHEN b.bottle_to_pick_sum + b.bottle_picked_sum = 0 THEN 100 ELSE ISNULL(b.bottle_picked_sum/(b.bottle_to_pick_sum + b.bottle_picked_sum)*100, 0) END,1) AS DECIMAL(4,1)) AS bottle_percent_complete_ldb, 
	   customer_count_ldb
FROM (
	SELECT a.whse_code,
       a.wave, 
	   a.shipment, 
	   a.appoint_date_time_ldb, 
	   a.carrier_service, 
	   SUM(a.case_to_pick) AS case_to_pick_sum, 
	   SUM(a.case_picked) AS case_picked_sum, 
	   SUM(a.bottle_to_pick) AS bottle_to_pick_sum, 
	   SUM(a.bottle_picked) AS bottle_picked_sum, 
	   COUNT(DISTINCT ship_custnum) AS customer_count_ldb
	FROM (
		SELECT wv_f.whse_code, 
		wv_f.wave, 
		om_f.shipment, 
		CAST(CONVERT(VARCHAR,CONVERT(DATE,om_f.ship_date)) +' '+ ISNULL(om_f.appoint_time, '00:00:00') AS DATETIME) as appoint_date_time_ldb, 
		om_f.carrier_service, 
		pm_f.custom_numeric_3 AS btlPerCase, 
		(SELECT ISNULL(SUM(qty),0)
                    FROM   cm_f, lc_f 
                    WHERE  cm_f.task_code = 'PICK'
                    AND  cm_f.whse_code = lc_f.whse_code
                    AND  cm_f.whse_code = od_f.whse_code
                    AND  cm_f.ob_oid = od_f.ob_oid
                    AND  cm_f.ob_type = od_f.ob_type
                    AND  cm_f.ob_lno = od_f.ob_lno
                    AND  cm_f.wave = om_f.wave
                    AND  cm_f.loc = lc_f.loc
                    AND  lc_f.area NOT IN 
                         (SELECT wsp.custom_char_01
                          FROM   wms_system_properties_ldb AS wsp
                          WHERE  wsp.property_name = 'BOTTLE_PICK_AREA'
                          AND  wsp.whse_code = lc_f.whse_code))/pm_f.custom_numeric_3 AS case_to_pick, 
		(SELECT ISNULL(SUM(qty),0)
                    FROM   iv_f, cn_f
                    WHERE  iv_f.ob_oid = od_f.ob_oid
                    AND  iv_f.ob_type = od_f.ob_type
                    AND  iv_f.ob_lno = od_f.ob_lno
                    AND  iv_f.whse_code = od_f.whse_code
                    AND  iv_f.cont = cn_f.cont
                    AND  iv_f.whse_code = cn_f.whse_code
                    AND  cn_f.cntype NOT IN 
                         (SELECT wsp.custom_char_01
                          FROM   wms_system_properties_ldb AS wsp
                          WHERE  wsp.whse_code = cn_f.whse_code
                          AND  wsp.property_name = 'BOTTLE_PICK_CONTAINER'))/pm_f.custom_numeric_3 AS case_picked, 
		(SELECT ISNULL(SUM(qty),0)
                    FROM   cm_f, lc_f, wms_system_properties_ldb AS wsp
                    WHERE  cm_f.task_code = 'PICK'
                    AND  cm_f.whse_code = od_f.whse_code
                    AND  cm_f.ob_oid = od_f.ob_oid
                    AND  cm_f.ob_type = od_f.ob_type
                    AND  cm_f.ob_lno = od_f.ob_lno
                    AND  cm_f.wave = om_f.wave
                    AND  cm_f.whse_code = lc_f.whse_code
                    AND  cm_f.loc = lc_f.loc
                    AND  lc_f.area = wsp.custom_char_01
                    AND  lc_f.whse_code = wsp.whse_code
                    AND  wsp.property_name = 'BOTTLE_PICK_AREA') AS bottle_to_pick, 
		(SELECT ISNULL(SUM(qty),0)
                    FROM   iv_f, cn_f, wms_system_properties_ldb AS wsp
                    WHERE  iv_f.ob_oid = od_f.ob_oid
                    AND  iv_f.ob_type = od_f.ob_type
                    AND  iv_f.ob_lno = od_f.ob_lno
                    AND  iv_f.whse_code = od_f.whse_code
                    AND  iv_f.cont = cn_f.cont
                    AND  iv_f.whse_code = cn_f.whse_code
                    AND  cn_f.cntype = wsp.custom_char_01
					AND  iv_f.whse_code = wsp.whse_code
                    AND  wsp.property_name = 'BOTTLE_PICK_CONTAINER') AS bottle_picked, 
		om_f.ship_custnum
		FROM   wv_f, om_f, od_f, pm_f     
		WHERE  wv_f.wave = om_f.wave
		AND  wv_f.whse_code = om_f.whse_code
		AND  om_f.ob_oid = od_f.ob_oid
		AND  om_f.ob_type = od_f.ob_type
		AND  om_f.whse_code = od_f.whse_code
		AND  od_f.sku = pm_f.sku
		AND  od_f.whse_code = pm_f.whse_code
		AND  CASE WHEN od_f.pkg = '*' THEN '' ELSE od_f.pkg END = pm_f.pkg) AS a
GROUP BY a.whse_code, a.wave, a.shipment, a.appoint_date_time_ldb, a.carrier_service) AS b;

GO

