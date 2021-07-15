DROP VIEW IF EXISTS [dbo].[v_ob_ord_mgmt_summ_ldb];
GO

CREATE VIEW [dbo].[v_ob_ord_mgmt_summ_ldb]
AS
WITH CTE_SrcData
AS(
SELECT 
	cast(ship_datetime AS DATE) as ship_date, 
	carrier_service as carrier_service, 
	ob_oid AS ob_oid,
	CASE WHEN cont =  '' THEN ( SELECT TOP 1 pallets FROM v_ob_volumetric_ldb WHERE whse_code= whse_code AND ob_oid= ob_oid) ELSE 0 END AS num_pallets,
	liquor_cases_ord,
	liquor_cases_pckd,
	liquor_btls_ord,
	liquor_btls_pckd
FROM dbo.ob_ord_summ_ldb
WHERE
	ship_complete = 'N'
)
SELECT 
ship_date, carrier_service, 
COUNT(DISTINCT ob_oid) AS num_orders, SUM(num_pallets) AS num_pallets, 
SUM(liquor_cases_ord) AS liquor_cases_ord, SUM(liquor_cases_pckd) AS liquor_cases_pckd,
SUM(liquor_btls_ord) AS liquor_btls_ord, SUM(liquor_btls_pckd) AS liquor_btls_pckd
FROM CTE_SrcData
GROUP BY ship_date, carrier_service


GO