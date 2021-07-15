-- create cpack

USE [sbx_94x_w]
GO

DECLARE
 @cont nvarchar(10) = 'C1000119', 
 @whse_code nvarchar(12) = 'VDC'

DECLARE
    @gn_type nvarchar(4) = 'CPCK',
	@gn_num    nvarchar(35),	
	@cpack_order_seq int = 0,
	@ob_oid    nvarchar(30),
	@om_rid    int,
	@station   char(4),
	@instance_name nvarchar(80),
	@create_user nvarchar(15) = 'system',
	@mod_counter int = 0,
	@documentTypeName nvarchar(10) = 'CP',
	@task_id int,
	@carrier_service nvarchar(30),	
	@shipment nvarchar(10);

BEGIN 		
	EXEC get_gn_f_doc_num_ldb @whse_code, @gn_type, @gn_num = @gn_num OUTPUT
		
	print N'Container Packing List : ' + @gn_num
		
	--update shipping activity
	UPDATE shipunit_h 
	SET cont_packlist = @gn_num
	WHERE whse_code = @whse_code
	AND cont = @cont;

	if @@rowcount = 0 
	return;
	
	SELECT TOP 1 @shipment = shipment FROM v_u_shipunit_f_ldb WHERE whse_code = @whse_code AND cont = @cont; 
	
	SELECT TOP 1 @om_rid = om_rid, @carrier_service = carrier_service FROM v_u_om_f WHERE whse_code = @whse_code AND shipment = @shipment; 
	 
	--create container packing record
	INSERT INTO cpack (whse_code, cont_packing_list, station, cont,  is_mult_bill_tos, is_mult_carriers, is_mult_ship_tos, create_stamp, create_user, mod_counter, memo)  
	VALUES (@whse_code, @gn_num, @station, @cont, 0, 0, 0, CURRENT_TIMESTAMP, @create_user, @mod_counter, '');

	SET @cpack_order_seq = ISNULL((SELECT MAX(cpack_order_seq) FROM cpack_order WHERE cpack_id = @@IDENTITY), 0);
	
	--create container packing order record
	INSERT INTO cpack_order (cpack_id , cpack_order_seq, om_rid, carrier_service, probill , fullskid, freight_class, num_crtn, wgt, total_ship_to_date_qty, total_extended_price, total_open_ord_qty, total_sales_order_qty, total_ship_qty, shipment , whse_code)
	VALUES (@@IDENTITY, @cpack_order_seq + 1, @om_rid, @carrier_service, 'NONE' , 'Y', '', 0, 0, 0, 0, 0, 0, 0, @shipment , @whse_code) 
	

END

GO

--Create mpack

DECLARE
 @cont nvarchar(10) = 'C1000119', 
 @whse_code nvarchar(12) = 'KDC'

DECLARE 
    @gn_num    nvarchar(35) = 'PACK567',	
	@create_user nvarchar(15) = 'system',
	@mod_counter int = 0,
	@documentTypeName nvarchar(10) = 'PA',
	@gn_type nvarchar(4) = 'PACK',
	@task_id int,
	@station   char(4) = 'BASE',
	@shipment nvarchar(10),
	@mpack_order_seq int = 0,
	@carrier_service nvarchar(30),	
	@om_rid    int;

BEGIN

	SELECT TOP 1 @shipment = shipment FROM v_u_shipunit_f_ldb WHERE whse_code = @whse_code AND cont = @cont; 
	
	SELECT TOP 1 @om_rid = om_rid, @carrier_service = carrier_service FROM v_u_om_f WHERE whse_code = @whse_code AND shipment = @shipment; 

	--create mpack record
	INSERT INTO mpack (whse_code, master_packing_list, station, tot_weight, total_pcs, create_stamp, create_user, mod_counter, memo, trailer)  
	VALUES ('KDC', 'PACK567', 'BASE', 0, 0, CURRENT_TIMESTAMP, 'system', 0, '', '');
	
	SET @mpack_order_seq = ISNULL((SELECT MAX(mpack_order_seq) FROM mpack_order WHERE mpack_id = @@IDENTITY), 0);

	--create mpack_order record
	INSERT INTO mpack_order(mpack_id, mpack_order_seq, om_rid, carrier_service, probill,  carrier_trailer, fullskid, num_crtn, wgt, total_ship_qty, total_extended_price, total_sales_order_qty, total_open_ord_qty, total_ship_to_date_qty, freight_class, shipment, whse_code)
	VALUES(@@IDENTITY, @mpack_order_seq + 1, @om_rid, @om_rid ,'NONE', )
	--
	
END

GO


select * from mpack_order