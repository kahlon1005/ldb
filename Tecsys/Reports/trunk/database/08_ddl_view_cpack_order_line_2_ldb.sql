CREATE OR ALTER VIEW [dbo].[cpack_ldb]
AS
SELECT o.mpack_id, o.whse_code from mpack o

GO

CREATE OR ALTER VIEW [dbo].[cpack_order_ldb]
AS
SELECT o.mpack_id, o.mpack_order_seq, o.whse_code, o.om_rid, o.carrier_service from mpack_order o
GO


CREATE OR ALTER VIEW [dbo].[cpack_order_line_2_ldb]
AS
SELECT mo.mpack_id, mo.mpack_order_seq, cl.cpack_id, cl.cpack_order_seq, cl.whse_code, cl.ob_oid, cl.om_rid, cl.cont, cl.line_seq, cl.sku, cl.sku_desc, 
	cl.non_liquor, cl.btl_cont, cl.volume, cl.pack_size, cl.cases, cl.bottles, cl.non_liquor_pieces, cl.cust_oid  
FROM cpack_order_line_ldb cl	
INNER JOIN cpack cp ON cp.whse_code = cl.whse_code AND cp.cpack_id = cl.cpack_id
INNER JOIN v_u_shipunit_f_ldb sh ON sh.whse_code = cp.whse_code AND sh.cont_packlist = cp.cont_packing_list
INNER JOIN mpack mp ON mp.whse_code = sh.whse_code AND mp.master_packing_list = sh.packlist
INNER JOIN mpack_order mo ON mo.whse_code = mp.whse_code AND mo.mpack_id = mp.mpack_id


GO
