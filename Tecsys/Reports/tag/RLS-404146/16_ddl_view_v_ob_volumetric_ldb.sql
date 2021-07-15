DROP VIEW IF EXISTS [dbo].[v_ob_volumetric_ldb];
GO

CREATE VIEW [dbo].[v_ob_volumetric_ldb]
AS
SELECT  od_f.whse_code, od_f.ob_oid, SUM(od_f.ord_vol) ord_vol, 
	CEILING(SUM(od_f.ord_vol)/(SELECT (intn_dpth*intn_hgt*intn_wid*3.53147E-5) * cast(cast(max_fill as decimal(18,4)) * 1/100 as decimal(18,2)) max_fill from cnty_f where cntype = 'RPAL')) pallets 
FROM (
	SELECT od_f.whse_code, od_f.ob_oid, od_f.ob_lno, od_f.sku, od_f.ord_qty, pm_f.custom_numeric_3 pkg_size, pm_f.uom1, 
	od_f.ord_qty * ((IIF(pm_f.uom1 = 'CASE1',(pm_f.dpth1 * pm_f.hgt1 * pm_f.wid1), (pm_f.dpth2 * pm_f.hgt2 * pm_f.wid2)) * 3.53147E-5)/pm_f.custom_numeric_3) ord_vol 
	FROM od_f 
	INNER JOIN pm_f ON pm_f.whse_code = od_f.whse_code AND pm_f.sku = od_f.sku AND pm_f.pkg = REPLACE(od_f.pkg, '*','')
	--where od_f.ob_oid = '1118705' --AND od_f.sku = '453092'
) od_f
GROUP BY od_f.ob_oid, od_f.whse_code

GO