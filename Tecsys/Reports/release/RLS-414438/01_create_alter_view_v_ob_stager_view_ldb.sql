DROP VIEW IF EXISTS [dbo].[v_ob_stager_view_ldb];
GO

CREATE VIEW [dbo].[v_ob_stager_view_ldb]
AS
SELECT q5.whse_code, q5.ob_oid,
	om_f.shipment, om_f.ship_custnum, om_f.ship_name,om_f.carrier_service, ca_f.carrier_code, 
    CONVERT(varchar,CONVERT(DATE,om_f.ship_date)) +' '+ ISNULL(om_f.appoint_time, '00:00:00') ship_datetime,
	RIGHT(q5.ob_oid,4) bignum,
	q5.t_cases_cont, q5.t_btls_cont, q5.fp_cont, q5.sh_cont,q5.ship_loc, q5.wr_cont, q5.btldspl_cont, q5.dr_cont, q5.oth_cont 
FROM (
	SELECT q4.whse_code, q4.ob_oid, SUM(q4.t_cases_cont) t_cases_cont, SUM(q4.t_btls_cont) t_btls_cont, 
									SUM(q4.fp_cont) fp_cont, SUM(q4.sh_cont) sh_cont, 
									q4.ship_loc, 
									SUM(q4.wr_cont) wr_cont, 
									SUM(btldspl_cont) btldspl_cont,
									SUM(q4.dr_cont) dr_cont,
           SUM(q4.t_cases_cont + q4.t_btls_cont - q4.fp_cont - q4.sh_cont - q4.wr_cont - dr_cont - btldspl_cont) oth_cont

	FROM (
		SELECT q3.whse_code, q3.ob_oid,
		  q3.t_cases_cont, q3.t_btls_cont,
		  IIF(lc_f.loc_type = 'FP', q3.t_cases_cont + q3.t_btls_cont, 0) fp_cont,
		  IIF(lc_f.loc_type = 'SHIP', q3.t_cases_cont + q3.t_btls_cont, 0) sh_cont,
		  IIF(lc_f.loc_type = 'SHIP', q3.loc, '') ship_loc,
		  IIF(lc_f.loc LIKE 'WRAPPER%', q3.t_cases_cont + q3.t_btls_cont, 0) wr_cont,
		  IIF(lc_f.loc = 'CNSOLIDATE' OR lc_f.loc = 'DR-BTLDSPL',  q3.t_cases_cont + q3.t_btls_cont, 0) btldspl_cont,
		  IIF(lc_f.loc_type = 'DOOR', q3.t_cases_cont + q3.t_btls_cont, 0) dr_cont
		FROM (
			SELECT q2.whse_code, q2.ob_oid, q2.loc, 
				SUM(q2.cases_cont) t_cases_cont, SUM(q2.btls_cont) t_btls_cont 
			FROM (
				SELECT q1.whse_code, q1.ob_oid,  q1.cont, q1.cntype, q1.loc, IIF(q1.cntype LIKE 'BX%', 0, 1) cases_cont,IIF(q1.cntype LIKE 'BX%', 1, 0) btls_cont FROM (
					SELECT q0.whse_code, q0.ob_oid, q0.cont, cn_f.cntype, 
					ISNULL((SELECT TOP 1 cm_f.loc FROM cm_f WHERE cm_f.whse_code = q0.whse_code AND cm_f.to_cont = q0.cont ORDER BY cm_f.cmd_seq ASC), cn_f.loc) loc				
					FROM (
						SELECT DISTINCT cm_f.whse_code, cm_f.ob_oid, IIF(cn_f.in_cont = ' ', cn_f.cont, cn_f.in_cont) cont
						FROM v_u_cm_f_ldb cm_f
						INNER JOIN cn_f ON cn_f.whse_code = cm_f.whse_code AND cn_f.cont = cm_f.cont
						WHERE cm_f.ob_oid != '' 
					) q0
					INNER JOIN cn_f ON cn_f.whse_code = q0.whse_code AND cn_f.cont = q0.cont
				)q1
			)q2
			GROUP BY q2.whse_code, q2.ob_oid, q2.loc
		)q3
		INNER JOIN lc_f ON lc_f.whse_code = q3.whse_code AND lc_f.loc = q3.loc
	)q4
	GROUP BY q4.whse_code, q4.ob_oid, q4.ship_loc
)q5
INNER JOIN om_f ON om_f.whse_code = q5.whse_code AND om_f.ob_oid = q5.ob_oid
INNER JOIN ca_f ON ca_f.carrier_service = om_f.carrier_service;

GO