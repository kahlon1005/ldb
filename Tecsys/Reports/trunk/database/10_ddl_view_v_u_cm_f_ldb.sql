CREATE OR ALTER VIEW [dbo].[v_u_cm_f_ldb]
AS
SELECT 'cm_f' mod_id, whse_code, ob_oid, ob_lno, sku, pkg, replace(to_cont,'SP','C') cont, qty FROM cm_f WHERE to_cont != ' '
UNION ALL
SELECT 'iv_f' mod_id, whse_code, ob_oid, ob_lno, sku, pkg, cont, qty FROM iv_f WHERE cont != ' ';	

GO

