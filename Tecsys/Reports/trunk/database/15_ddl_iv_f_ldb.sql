CREATE OR ALTER  VIEW [dbo].[v_u_iv_f_ldb]
AS
SELECT iv_rid, whse_code, ob_oid, ob_lno, cont, sku, pkg, qty FROM [dbo].[iv_f]
UNION ALL
SELECT iv_rid, whse_code, ob_oid, ob_lno, cont, sku, pkg, qty  FROM [dbo].[iv_h]

GO