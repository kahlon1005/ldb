DROP VIEW IF EXISTS [dbo].[mpack_ldb]
GO

CREATE VIEW [dbo].[mpack_ldb]
AS
SELECT o.mpack_id, o.whse_code from mpack o 

GO

DROP VIEW IF EXISTS [dbo].[mpack_order_ldb]
GO

CREATE VIEW [dbo].[mpack_order_ldb]
AS
SELECT o.mpack_id, o.mpack_order_seq, o.whse_code, o.om_rid, o.carrier_service, dbo.mpack_loc_list_ldb(o.whse_code,o.mpack_id,o.mpack_order_seq) locations_ldb from mpack_order o 

GO


DROP VIEW IF EXISTS [dbo].[mpack_order_line_ldb]
GO

CREATE VIEW  [dbo].[mpack_order_line_ldb]
(mpack_id, mpack_order_seq, whse_code, cust_oid, cases) AS
SELECT q2.mpack_id, q2.mpack_order_seq, q2.whse_code, q2.cust_oid, FLOOR(q2.liquor_cases) cases 
FROM (
	SELECT mpack_order.mpack_id, mpack_order.mpack_order_seq, q3.whse_code, q3.cust_oid, SUM(q3.liquor_cases) liquor_cases FROM (
		SELECT q1.whse_code, q1.ob_oid, q1.cust_oid, q1.cont, q1.liquor_cases + q1.bottle_case liquor_cases
		FROM(
			SELECT q.whse_code, q.ob_oid, q.cust_oid, IIF(cn_f.in_cont <> ' ', cn_f.in_cont, q.cont) cont,  
			    COUNT(distinct IIF(cn_f.in_cont = ' ', IIF(cn_f.cntype LIKE 'BX%', q.cont, null), q.cont)) bottle_case,
				SUM(IIF(cn_f.cntype LIKE 'BX%', 0, (q.qty/ISNULL(pm_f.custom_numeric_3,1)))) liquor_cases,
				SUM(IIF(cn_f.cntype LIKE 'BX%', q.qty, 0)) liquor_units	
			  FROM (
				SELECT iv_f.whse_code, iv_f.ob_oid, od_f.cust_oid, iv_f.cont, iv_f.sku, iv_f.pkg, SUM(iv_f.qty) qty 
				FROM v_u_od_f od_f
				INNER JOIN iv_f ON iv_f.whse_code = od_f.whse_code AND iv_f.ob_oid = od_f.ob_oid AND iv_f.ob_lno = od_f.ob_lno
--WHERE od_f.ob_oid = '828526'
				GROUP BY iv_f.whse_code, iv_f.ob_oid, od_f.cust_oid, iv_f.cont, iv_f.sku, iv_f.pkg
			) q
			INNER JOIN pm_f ON pm_f.whse_code = q.whse_code AND pm_f.sku = q.sku AND pm_f.pkg = q.pkg
			LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'
			INNER JOIN cn_f ON cn_f.whse_code = q.whse_code AND cn_f.cont = q.cont
			WHERE p.custom_char_01 IS NULL
			GROUP BY q.whse_code, q.ob_oid, q.cust_oid, IIF(cn_f.in_cont <> ' ', cn_f.in_cont, q.cont)
			) q1
		)q3
	INNER JOIN om_f ON om_f.whse_code = q3.whse_code AND om_f.ob_oid = q3.ob_oid
	INNER JOIN mpack_order ON mpack_order.whse_code = om_f.whse_code AND mpack_order.om_rid = om_f.om_rid
	GROUP BY mpack_order.mpack_id, mpack_order.mpack_order_seq, q3.whse_code, q3.cust_oid
)q2


GO


DROP VIEW IF EXISTS [dbo].[mpack_order_line_2_ldb]
GO

CREATE VIEW [dbo].[mpack_order_line_2_ldb]
(mpack_id, mpack_order_seq, whse_code, cont, liquor_cases, liquor_weight, non_liquor_pieces, non_liquor_weight,description_list_ldb) as
SELECT mpack_order.mpack_id, mpack_order.mpack_order_seq, q5.whse_code, q5.cont, 
	FLOOR(q5.liquor_cases + q5.bottle_case) liquor_cases, 
	CAST(IIF(liquor_wgt > 0, sh_f.wgt, 0) as decimal(14,2)) liquor_weight,
	FLOOR(q5.non_liquor_pieces) non_liquor_pieces,	
	CAST(IIF(liquor_wgt > 0, 0, sh_f.wgt)  as decimal(14,2)) non_liquor_weight, dbo.mpack_item_desc_ldb(mpack_order.whse_code,mpack_order.mpack_id,mpack_order.mpack_order_seq,q5.cont) description_list_ldb	
FROM (
	SELECT q4.whse_code, q4.ob_oid, IIF(q4.in_cont = ' ', q4.cont, q4.in_cont) cont, 
		COUNT(distinct IIF(q4.in_cont = ' ', IIF(cn_f.cntype LIKE 'BX%', q4.cont, null), q4.cont)) bottle_case,
		SUM(q4.liquor_cases) liquor_cases, 
		SUM(q4.liquor_units) liquor_units, 
		SUM(q4.liquor_wgt) liquor_wgt, 
		SUM(q4.non_liquor_pieces) non_liquor_pieces, 
		SUM(q4.non_liquor_wgt) non_liquor_wgt 
	FROM (
		SELECT q3.whse_code, q3.ob_oid, q3.cont, q3.in_cont,  
			SUM(q3.liquor_cases) liquor_cases, 
			SUM(q3.liquor_units) liquor_units,
			SUM(q3.liquor_wgt) liquor_wgt, 
			SUM(q3.non_liquor_pieces) non_liquor_pieces, 
			SUM(q3.non_liquor_wgt) non_liquor_wgt 
		FROM (
			SELECT q2.whse_code, q2.ob_oid, q2.sku, q2.sku_desc, q2.pkg, q2.cont, q2.in_cont, q2.cntype,
				(q2.liquor_qty/q2.qty1in2) liquor_cases, 
				(q2.liquor_qty%q2.qty1in2) + q2.liquor_units liquor_units, 
				(q2.liquor_qty + q2.liquor_units) * q2.wgt1 liquor_wgt, 
				(q2.non_liquor_qty) non_liquor_pieces,
				(q2.non_liquor_qty * q2.wgt1) non_liquor_wgt  
			FROM (
				SELECT q1.whse_code, q1.ob_oid, q1.sku, q1.sku_desc, q1.pkg, q1.qty1in2, q1.wgt1, q1.cont, cn_f.in_cont, cn_f.cntype, 
				IIF(cn_f.cntype LIKE 'BX%', 0, q1.liquor_qty) liquor_qty,
				IIF(cn_f.cntype LIKE 'BX%', q1.liquor_qty, 0) liquor_units,				
				q1.non_liquor_qty 
				FROM ( 
					SELECT q.whse_code, q.ob_oid, q.sku, pm_f.sku_desc, q.pkg, ISNULL(pm_f.custom_numeric_3,1) qty1in2, pm_f.wgt1, q.cont, 
						IIF(p.custom_char_01 IS NULL, qty, 0) liquor_qty, 
						IIF(p.custom_char_01 IS NULL, 0, qty) non_liquor_qty
					FROM (
						SELECT iv_f.whse_code, iv_f.ob_oid, iv_f.sku, iv_f.pkg, iv_f.cont, SUM(iv_f.qty) qty
						FROM iv_f 
						WHERE iv_f.ob_oid <> ' '
--AND iv_f.ob_oid = '828526'
						GROUP BY iv_f.whse_code, iv_f.ob_oid, iv_f.sku, iv_f.pkg, iv_f.cont
					) q
					INNER JOIN pm_f ON pm_f.whse_code = q.whse_code AND pm_f.sku = q.sku AND pm_f.pkg = q.pkg
					LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'
				) q1
				INNER JOIN cn_f ON cn_f.whse_code = q1.whse_code AND cn_f.cont = q1.cont
			) q2	
		) q3
		GROUP BY q3.whse_code, q3.ob_oid, q3.cont, q3.in_cont
	) q4
	INNER JOIN cn_f ON cn_f.whse_code = q4.whse_code AND cn_f.cont = q4.cont
	GROUP BY q4.whse_code, q4.ob_oid, IIF(q4.in_cont = ' ', q4.cont, q4.in_cont)
) q5
INNER JOIN om_f ON om_f.whse_code = q5.whse_code AND om_f.ob_oid = q5.ob_oid
INNER JOIN mpack_order ON mpack_order.whse_code = om_f.whse_code AND mpack_order.om_rid = om_f.om_rid
INNER JOIN shipunit_f sh_f ON sh_f.whse_code = q5.whse_code AND sh_f.cont = q5.cont

GO

DROP VIEW IF EXISTS [dbo].[fcredit_ldb]
GO

CREATE VIEW [dbo].[fcredit_ldb]
AS
SELECT o.mpack_id, o.whse_code from mpack o

GO

DROP VIEW IF EXISTS [dbo].[fcredit_order_ldb]
GO

CREATE VIEW [dbo].[fcredit_order_ldb]
AS
SELECT o.mpack_id, o.mpack_order_seq, o.whse_code, o.om_rid, o.carrier_service from mpack_order o

GO

DROP VIEW IF EXISTS [dbo].[fcredit_order_line_ldb]
GO

CREATE VIEW [dbo].[fcredit_order_line_ldb]
AS
SELECT mpack_order.mpack_id, mpack_order.mpack_order_seq, q2.whse_code, q2.ob_oid, q2.sku, q2.sku_desc, 
	IIF(q2.non_liquor IS NULL,'N','Y') non_liquor, 
	CAST(q2.volume as decimal(14,3)) volume, 
	CAST(q2.pack_size as Integer) pack_size, 
	CAST(q2.cases  as Integer) cases, 
	CAST(IIF(q2.non_liquor IS NULL,q2.bottles,0) as Integer) bottles, 
	CAST(q2.non_liquor_pieces as Integer) non_liquor_pieces, 
	ISNULL(q2.cust_oid, ' ') cust_oid  
FROM (
	SELECT q0.whse_code, q0.ob_oid, q0.sku, pm_f.sku_desc, p.custom_char_01 non_liquor,
		pm_f.custom_numeric_5 volume, ISNULL(pm_f.custom_numeric_3,1) pack_size, q0.cust_oid, 
		FLOOR((q0.ord_qty - SUM(qty))/ISNULL(pm_f.custom_numeric_3,1)) cases, 
		FLOOR((q0.ord_qty - SUM(qty))%ISNULL(pm_f.custom_numeric_3,1)) bottles,
		IIF(p.custom_char_01 IS NULL, 0, (q0.ord_qty-SUM(qty))) non_liquor_pieces
	FROM (
			SELECT od_f.whse_code, od_f.ob_oid, od_f.ob_lno, od_f.sku, od_f.pkg, od_f.cust_oid, sum(od_f.ord_qty) ord_qty
			FROM v_u_od_f od_f
--WHERE od_f.ob_oid = '828525'
			GROUP BY od_f.whse_code, od_f.ob_oid, od_f.ob_lno, od_f.sku, od_f.pkg, od_f.cust_oid
	) q0
	INNER JOIN iv_f ON iv_f.whse_code = q0.whse_code AND iv_f.ob_oid = q0.ob_oid AND iv_f.ob_lno = q0.ob_lno AND iv_f.sku = q0.sku AND iv_f.pkg = REPLACE(q0.pkg, '*', ' ')
	INNER JOIN pm_f ON pm_f.whse_code = q0.whse_code AND pm_f.sku = q0.sku AND pm_f.pkg = REPLACE(q0.pkg, '*', ' ')
	LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'
	GROUP BY q0.whse_code, q0.ob_oid, q0.sku, pm_f.sku_desc, p.custom_char_01, pm_f.custom_numeric_5, ISNULL(pm_f.custom_numeric_3,1), q0.cust_oid, q0.ord_qty
) q2
INNER JOIN om_f ON om_f.whse_code = q2.whse_code AND om_f.ob_oid = q2.ob_oid
INNER JOIN mpack_order ON mpack_order.whse_code = om_f.whse_code AND mpack_order.om_rid = om_f.om_rid

GO