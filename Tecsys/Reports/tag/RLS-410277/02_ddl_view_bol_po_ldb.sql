CREATE OR ALTER VIEW [dbo].[bol_po_ldb]
AS
SELECT q3.whse_code, q3.bol_id, q3.bol_po_seq, q3.ob_oid,
	SUM(q3.liquor_cases) liquor_cartons,
	CAST(SUM(q3.liquor_weight) as decimal(14, 2)) liquor_weight,
	SUM(q3.non_liquor_pieces) non_liquor_pieces,
	CAST(SUM(q3.non_liquor_weight) as decimal(14,2)) non_liquor_weight
FROM ( 
SELECT q2.whse_code, q2.bol_id, q2.bol_po_seq, q2.ob_oid, q2.shipunit_rid,  q2.cont, 
	q2.liquor_cases + q2.bottle_case liquor_cases, 
	IIF(q2.liquor_weight > 0, q2.liquor_weight + cnty_f.wgt, 0) liquor_weight,
	q2.non_liquor_pieces,
	IIF(q2.liquor_weight > 0, q2.non_liquor_weight ,q2.non_liquor_weight + cnty_f.wgt) non_liquor_weight
FROM (
SELECT q1.whse_code, q1.bol_id, q1.bol_po_seq, q1.ob_oid, q1.shipunit_rid, IIF(cn_f.in_cont = ' ', q1.cont, cn_f.in_cont) cont
    , COUNT(distinct IIF(cn_f.in_cont = ' ', IIF(cn_f.cntype LIKE 'BX%', q1.cont, null), q1.cont)) bottle_case	
	, SUM(q1.liquor_cases) liquor_cases
	, SUM(q1.liquor_units) liquor_units
	, SUM(q1.liquor_weight) liquor_weight
	, SUM(q1.non_liquor_weight) non_liquor_weight
	, SUM(q1.non_liquor_pieces) non_liquor_pieces
FROM (
SELECT q.whse_code, q.bol_id, q.bol_po_seq, q.ob_oid, q.shipunit_rid, q.cont, q.cntype,
		q.sku, q.sku_desc,
		SUM(FLOOR(IIF(q.non_liquor = 'N', IIF(q.cntype LIKE 'BX%',0,q.qty/q.qty1in2), 0))) liquor_cases, 
		SUM(FLOOR(IIF(q.non_liquor = 'N', IIF(q.cntype LIKE 'BX%',  q.qty, q.qty%q.qty1in2), 0))) liquor_units, 
		SUM(IIF(q.non_liquor = 'N', q.qty*q.unit_wgt, 0)) liquor_weight, 
		SUM(FLOOR(IIF(q.non_liquor = 'Y', q.qty, 0))) non_liquor_pieces,
		SUM(IIF(q.non_liquor = 'Y', (q.qty*q.unit_wgt), 0)) non_liquor_weight
FROM (
	SELECT bol_po.whse_code, bol_po.bol_id, bol_po.bol_po_seq, iv_f.ob_oid, iv_f.shipunit_rid, cn_f.cont, cn_f.cntype,
		    pm_f.sku, pm_f.sku_desc, IIF(prop.custom_char_01 IS NULL,'N','Y') non_liquor, pm_f.wgt1 unit_wgt, ISNULL(pm_f.custom_numeric_3,1) qty1in2,			
		    SUM(iv_f.qty) qty
	FROM bol_po
		INNER JOIN iv_f ON bol_po.whse_code = iv_f.whse_code AND iv_f.ob_oid = bol_po.ship_po
		INNER JOIN cn_f ON cn_f.whse_code = iv_f.whse_code AND cn_f.cont = iv_f.cont
		INNER JOIN pm_f ON pm_f.whse_code = iv_f.whse_code AND pm_f.sku = iv_f.sku AND pm_f.pkg = iv_f.pkg
		LEFT JOIN wms_system_properties_ldb prop ON pm_f.custom_char_6 = prop.custom_char_01 AND prop.property_name = 'NON-LIQUOR'	
--WHERE iv_f.ob_oid = '828526'
	GROUP BY bol_po.whse_code, bol_po.bol_id, bol_po.bol_po_seq, iv_f.ob_oid, iv_f.shipunit_rid, cn_f.cont, cn_f.cntype,
		    pm_f.sku, pm_f.sku_desc, IIF(prop.custom_char_01 IS NULL,'N','Y'), pm_f.wgt1, ISNULL(pm_f.custom_numeric_3,1)
) q 
GROUP BY q.whse_code, q.bol_id, q.bol_po_seq, q.ob_oid, q.shipunit_rid, q.cont, q.cntype,q.sku, q.sku_desc
) q1
INNER JOIN cn_f ON cn_f.whse_code = q1.whse_code AND cn_f.cont = q1.cont
GROUP BY q1.whse_code, q1.bol_id, q1.bol_po_seq, q1.ob_oid, q1.shipunit_rid, IIF(cn_f.in_cont = ' ', q1.cont, cn_f.in_cont)
) q2
INNER JOIN cn_f ON cn_f.whse_code = q2.whse_code AND cn_f.cont = q2.cont
INNER JOIN cnty_f ON cnty_f.whse_code = cn_f.whse_code AND cnty_f.cntype = cn_f.cntype
) q3 
GROUP BY  q3.whse_code, q3.bol_id, q3.bol_po_seq, q3.ob_oid

GO

