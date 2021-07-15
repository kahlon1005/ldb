USE [int3_94x_w] 
GO

SET NOCOUNT OFF;
SET CURSOR_CLOSE_ON_COMMIT ON;
SET IMPLICIT_TRANSACTIONS ON;

PRINT N'Turn AUTO COMMIT OFF'
PRINT N'';
		

DECLARE 
	@archive_date DATETIME,
	@archive_period NVARCHAR(3),
	@ErrorMessage NVARCHAR(4000),  
	@ErrorSeverity INT,  
	@ErrorState INT

BEGIN TRY  

	SELECT @archive_period = custom_char_01 FROM wms_system_properties_ldb WHERE property_name = 'WMS_ARCHIVE_PERIOD'

	IF (@@rowcount = 0)  OR (CAST(@archive_period AS INT) < 1) 
	SELECT @archive_period = 1;

	SELECT @archive_date = DateAdd(m, - CAST(@archive_period AS INT), CONVERT(DATE, GETDATE()-DAY(GETDATE())+1 , 120));
 
	PRINT N'Archive starting as of  - '  
    + RTRIM(CAST(@archive_date AS nvarchar(30)))  
    + N'.';  

	PRINT N'Archiving manifest Start'
	SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[manifest_a] ON	
	DECLARE @v_manifest_id     INTEGER
	
	DECLARE cur_manifest CURSOR local forward_only FOR
	SELECT manifest_id FROM manifest
	WHERE create_stamp <= @archive_date;				
	
	OPEN cur_manifest
	FETCH NEXT FROM cur_manifest INTO @v_manifest_id;

	-- start looping
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- start archiving om_h
		PRINT N'Archiving manifest '+ CAST(@v_manifest_id AS nvarchar)
			
		INSERT INTO [dbo].[manifest_a]
           ([manifest_id]
		   ,[manifest]
           ,[station]
           ,[carrier_code]
           ,[carrier_service]
           ,[trailer]
           ,[seal]
           ,[creation_queue_msg_id]
           ,[print_queue_msg_id]
           ,[create_stamp]
           ,[create_user]
           ,[mod_stamp]
           ,[mod_user]
           ,[mod_counter]
           ,[whse_code])
		SELECT 
			[manifest_id]
		   ,[manifest]
           ,[station]
           ,[carrier_code]
           ,[carrier_service]
           ,[trailer]
           ,[seal]
           ,[creation_queue_msg_id]
           ,[print_queue_msg_id]
           ,[create_stamp]
           ,[create_user]
           ,[mod_stamp]
           ,[mod_user]
           ,[mod_counter]
           ,[whse_code]
		FROM manifest a
		WHERE manifest_id = @v_manifest_id;
				  
		INSERT INTO [dbo].[manifest_l_a]
           ([manifest_id]
           ,[manifest_l_seq]
           ,[probill]
           ,[bol]
           ,[loose_carton_qty]
           ,[pallet_qty]
           ,[carton_qty]
           ,[pallet_weight]
           ,[carton_weight]
           ,[whse_code])				  
		SELECT 
            [manifest_id]
           ,[manifest_l_seq]
           ,[probill]
           ,[bol]
           ,[loose_carton_qty]
           ,[pallet_qty]
           ,[carton_qty]
           ,[pallet_weight]
           ,[carton_weight]
           ,[whse_code]
		FROM manifest_l l
		WHERE manifest_id = @v_manifest_id;
		
		DELETE FROM manifest_l WHERE manifest_id = @v_manifest_id;

		FETCH NEXT FROM cur_manifest INTO @v_manifest_id;
	END
	
	DELETE FROM manifest WHERE create_stamp <= @archive_date;	
	
	PRINT N'Archiving Manifest Finish'
	COMMIT

END TRY  

BEGIN CATCH  
    PRINT N'Archiving Failed.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  

SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[manifest_a] OFF	
SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[bol_a] ON	

BEGIN TRY
	PRINT N'Archiving Bol Start'
	DECLARE @v_bol_id		   INTEGER
		
	DECLARE cur_bol CURSOR local forward_only FOR
	SELECT bol_id FROM bol
	WHERE create_stamp <= @archive_date;				
	
	OPEN cur_bol
	FETCH NEXT FROM cur_bol INTO @v_bol_id;

	-- start looping
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- start archiving om_h
		PRINT N'Archiving Bol '+ CAST(@v_bol_id AS nvarchar)

		INSERT INTO [dbo].[bol_a]
           ([bol_id]
		   ,[bol]
           ,[shipment]
           ,[station]
           ,[probill]
           ,[carrier_code]
           ,[carrier_service]
           ,[trailer]
           ,[seal]
           ,[freight_payment_terms_type]
           ,[ship_name]
           ,[ship_addr1]
           ,[ship_addr2]
           ,[ship_addr3]
           ,[ship_city]
           ,[ship_state]
           ,[ship_zip]
           ,[ship_cntry]
           ,[ship_custnum]
           ,[ship_phone]
           ,[total_pallet_qty]
           ,[total_carton_qty]
           ,[total_weight]
           ,[creation_queue_msg_id]
           ,[print_queue_msg_id]
           ,[create_stamp]
           ,[create_user]
           ,[mod_stamp]
           ,[mod_user]
           ,[mod_counter]
           ,[whse_code])
		SELECT 
			[bol_id]
		   ,[bol]
           ,[shipment]
           ,[station]
           ,[probill]
           ,[carrier_code]
           ,[carrier_service]
           ,[trailer]
           ,[seal]
           ,[freight_payment_terms_type]
           ,[ship_name]
           ,[ship_addr1]
           ,[ship_addr2]
           ,[ship_addr3]
           ,[ship_city]
           ,[ship_state]
           ,[ship_zip]
           ,[ship_cntry]
           ,[ship_custnum]
           ,[ship_phone]
           ,[total_pallet_qty]
           ,[total_carton_qty]
           ,[total_weight]
           ,[creation_queue_msg_id]
           ,[print_queue_msg_id]
           ,[create_stamp]
           ,[create_user]
           ,[mod_stamp]
           ,[mod_user]
           ,[mod_counter]
           ,[whse_code]
		FROM bol a
		WHERE bol_id = @v_bol_id;
		
		INSERT INTO [dbo].[bol_po_a]
           ([bol_id]
           ,[bol_po_seq]
           ,[ship_po]
           ,[whse_code])
		SELECT
		    [bol_id]
           ,[bol_po_seq]
           ,[ship_po]
           ,[whse_code]
		FROM bol_po p   
		WHERE bol_id = @v_bol_id;
		
		INSERT INTO [dbo].[bol_l_a]
           ([bol_id]
           ,[bol_l_seq]
           ,[pallet_qty]
           ,[carton_qty]
           ,[weight]
           ,[nmfc_number]
           ,[nmfc_sub_number]
           ,[freight_class]
           ,[whse_code])
		SELECT 
            [bol_id]
           ,[bol_l_seq]
           ,[pallet_qty]
           ,[carton_qty]
           ,[weight]
           ,[nmfc_number]
           ,[nmfc_sub_number]
           ,[freight_class]
           ,[whse_code]
		FROM bol_l l  
		WHERE bol_id = @v_bol_id;

		DELETE FROM bol_l WHERE bol_id = @v_bol_id;
		DELETE FROM bol_po WHERE bol_id = @v_bol_id;

		FETCH NEXT FROM cur_bol INTO @v_bol_id;
	END
	DELETE FROM bol WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving Bol Finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving Failed.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  
SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[bol_a] OFF	
SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[cpack_a] ON	

BEGIN TRY
	PRINT N'Archiving cpack Start'
	
	DECLARE @v_cpack_id INTEGER	 
	
	DECLARE cur_cpack CURSOR local forward_only FOR
	SELECT cpack_id FROM cpack
	WHERE create_stamp <= @archive_date;				
	
	OPEN cur_cpack
	FETCH NEXT FROM cur_cpack INTO @v_cpack_id;

	-- start looping
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- start archiving om_h
		PRINT N'Archiving cpack '+ CAST(@v_cpack_id AS nvarchar)
		
		INSERT INTO [dbo].[cpack_a]
           ([cpack_id]
		   ,[cont_packing_list]
           ,[station]
           ,[memo]
           ,[cont]
           ,[is_mult_ship_tos]
           ,[is_mult_bill_tos]
           ,[is_mult_carriers]
           ,[creation_queue_msg_id]
           ,[print_queue_msg_id]
           ,[create_stamp]
           ,[create_user]
           ,[mod_stamp]
           ,[mod_user]
           ,[mod_counter]
           ,[whse_code])
		SELECT
			[cpack_id]
		   ,[cont_packing_list]
           ,[station]
           ,[memo]
           ,[cont]
           ,[is_mult_ship_tos]
           ,[is_mult_bill_tos]
           ,[is_mult_carriers]
           ,[creation_queue_msg_id]
           ,[print_queue_msg_id]
           ,[create_stamp]
           ,[create_user]
           ,[mod_stamp]
           ,[mod_user]
           ,[mod_counter]
           ,[whse_code]
		FROM cpack
		WHERE cpack_id = @v_cpack_id;
			
		INSERT INTO [dbo].[cpack_order_a]
           ([cpack_id]
           ,[cpack_order_seq]
           ,[om_rid]
           ,[carrier_service]
           ,[probill]
           ,[fullskid]
           ,[num_crtn]
           ,[wgt]
           ,[total_ship_qty]
           ,[total_extended_price]
           ,[total_sales_order_qty]
           ,[total_open_ord_qty]
           ,[total_ship_to_date_qty]
           ,[freight_class]
           ,[shipment]
           ,[whse_code])
		SELECT
            [cpack_id]
           ,[cpack_order_seq]
           ,[om_rid]
           ,[carrier_service]
           ,[probill]
           ,[fullskid]
           ,[num_crtn]
           ,[wgt]
           ,[total_ship_qty]
           ,[total_extended_price]
           ,[total_sales_order_qty]
           ,[total_open_ord_qty]
           ,[total_ship_to_date_qty]
           ,[freight_class]
           ,[shipment]
           ,[whse_code]
		FROM cpack_order
		WHERE cpack_id = @v_cpack_id;
			
		INSERT INTO [dbo].[cpack_order_line_a]
           ([cpack_id]
           ,[cpack_order_seq]
           ,[cpack_order_line_seq]
           ,[od_rid]
           ,[sku]
           ,[pkg]
           ,[order_qty]
           ,[ship_qty]
           ,[extended_price]
           ,[sales_order_qty]
           ,[units_ordered]
           ,[inner_cont]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[uom2]
           ,[uom3]
           ,[uom4]
           ,[qty1in2]
           ,[qty2in3]
           ,[qty3in4]
           ,[wgt1]
           ,[wgt2]
           ,[wgt3]
           ,[wgt4]
           ,[load_uom]
           ,[crtn_uom]
           ,[load_factor]
           ,[is_backordered]
           ,[uom5]
           ,[uom6]
           ,[qty4in5]
           ,[qty5in6]
           ,[wgt5]
           ,[wgt6]
           ,[whse_code])			
		SELECT 
            [cpack_id]
           ,[cpack_order_seq]
           ,[cpack_order_line_seq]
           ,[od_rid]
           ,[sku]
           ,[pkg]
           ,[order_qty]
           ,[ship_qty]
           ,[extended_price]
           ,[sales_order_qty]
           ,[units_ordered]
           ,[inner_cont]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[uom2]
           ,[uom3]
           ,[uom4]
           ,[qty1in2]
           ,[qty2in3]
           ,[qty3in4]
           ,[wgt1]
           ,[wgt2]
           ,[wgt3]
           ,[wgt4]
           ,[load_uom]
           ,[crtn_uom]
           ,[load_factor]
           ,[is_backordered]
           ,[uom5]
           ,[uom6]
           ,[qty4in5]
           ,[qty5in6]
           ,[wgt5]
           ,[wgt6]
           ,[whse_code]	
		FROM cpack_order_line
		WHERE cpack_id = @v_cpack_id;
		
		INSERT INTO [dbo].[cpack_order_line_lot_a]
           ([cpack_id]
           ,[cpack_order_seq]
           ,[cpack_order_line_seq]
           ,[cpack_order_line_lot_seq]
           ,[lot]
           ,[product_exp_date]
           ,[whse_code])
		SELECT   
            [cpack_id]
           ,[cpack_order_seq]
           ,[cpack_order_line_seq]
           ,[cpack_order_line_lot_seq]
           ,[lot]
           ,[product_exp_date]
           ,[whse_code]
		FROM cpack_order_line_lot
		WHERE cpack_id = @v_cpack_id;
		
		INSERT INTO [dbo].[cpack_order_line_serial_a]
           ([cpack_id]
           ,[cpack_order_seq]
           ,[cpack_order_line_seq]
           ,[cpack_order_line_serial_seq]
           ,[serial_num]
           ,[whse_code])
		SELECT 
            [cpack_id]
           ,[cpack_order_seq]
           ,[cpack_order_line_seq]
           ,[cpack_order_line_serial_seq]
           ,[serial_num]
           ,[whse_code]
		FROM cpack_order_line_serial
		WHERE cpack_id = @v_cpack_id;

		DELETE FROM cpack_order_line_serial WHERE cpack_id = @v_cpack_id;
		DELETE FROM cpack_order_line_lot WHERE cpack_id = @v_cpack_id;
		DELETE FROM cpack_order_line WHERE cpack_id = @v_cpack_id;
		DELETE FROM cpack_order WHERE cpack_id = @v_cpack_id;
		
		FETCH NEXT FROM cur_cpack INTO @v_cpack_id;
	END
	DELETE FROM cpack WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving cpack Finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving Failed.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  
SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[cpack_a] OFF	
SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[mpack_a] ON	

BEGIN TRY
	PRINT N'Archiving mpack Start'
	
	DECLARE @v_mpack_id INTEGER	 
	
	DECLARE cur_mpack CURSOR local forward_only FOR
	SELECT mpack_id FROM mpack
	WHERE create_stamp <= @archive_date;				
	
	OPEN cur_mpack
	FETCH NEXT FROM cur_mpack INTO @v_mpack_id;

	-- start looping
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- start archiving mpack
		PRINT N'Archiving mpack '+ CAST(@v_mpack_id AS nvarchar)

		INSERT INTO [dbo].[mpack_a]
           ([mpack_id]
		   ,[master_packing_list]
           ,[station]
           ,[memo]
           ,[trailer]
           ,[creation_queue_msg_id]
           ,[print_queue_msg_id]
           ,[tot_weight]
           ,[total_pcs]
           ,[create_stamp]
           ,[create_user]
           ,[mod_stamp]
           ,[mod_user]
           ,[mod_counter]
           ,[whse_code])
		SELECT
            [mpack_id]
		   ,[master_packing_list]
           ,[station]
           ,[memo]
           ,[trailer]
           ,[creation_queue_msg_id]
           ,[print_queue_msg_id]
           ,[tot_weight]
           ,[total_pcs]
           ,[create_stamp]
           ,[create_user]
           ,[mod_stamp]
           ,[mod_user]
           ,[mod_counter]
           ,[whse_code]
		FROM mpack 
		WHERE mpack_id = @v_mpack_id;
		
		INSERT INTO [dbo].[mpack_order_a]
           ([mpack_id]
           ,[mpack_order_seq]
           ,[om_rid]
           ,[probill]
           ,[carrier_service]
           ,[carrier_trailer]
           ,[fullskid]
           ,[num_crtn]
           ,[wgt]
           ,[total_ship_qty]
           ,[total_extended_price]
           ,[total_sales_order_qty]
           ,[total_open_ord_qty]
           ,[total_ship_to_date_qty]
           ,[freight_class]
           ,[shipment]
           ,[whse_code]
           ,[seller_name]
           ,[seller_gln]
           ,[seller_address1]
           ,[seller_address2]
           ,[seller_city]
           ,[seller_state]
           ,[seller_zip]
           ,[seller_country]
           ,[seller_dscsa_statement])
		SELECT
            [mpack_id]
           ,[mpack_order_seq]
           ,[om_rid]
           ,[probill]
           ,[carrier_service]
           ,[carrier_trailer]
           ,[fullskid]
           ,[num_crtn]
           ,[wgt]
           ,[total_ship_qty]
           ,[total_extended_price]
           ,[total_sales_order_qty]
           ,[total_open_ord_qty]
           ,[total_ship_to_date_qty]
           ,[freight_class]
           ,[shipment]
           ,[whse_code]
           ,[seller_name]
           ,[seller_gln]
           ,[seller_address1]
           ,[seller_address2]
           ,[seller_city]
           ,[seller_state]
           ,[seller_zip]
           ,[seller_country]
           ,[seller_dscsa_statement]		   
		FROM mpack_order
		WHERE mpack_id = @v_mpack_id;
		
		INSERT INTO [dbo].[mpack_order_line_a]
           ([mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[od_rid]
           ,[sku]
           ,[pkg]
           ,[is_mult_cont]
           ,[cont]
           ,[order_qty]
           ,[ship_qty]
           ,[total_qty]
           ,[total_num_cartons]
           ,[calc_weight]
           ,[extended_price]
           ,[sales_order_qty]
           ,[units_ordered]
           ,[total_extended_price]
           ,[total_sales_order_qty]
           ,[total_open_ord_qty]
           ,[total_ship_to_date_qty]
           ,[whse_code])
		SELECT 
			[mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[od_rid]
           ,[sku]
           ,[pkg]
           ,[is_mult_cont]
           ,[cont]
           ,[order_qty]
           ,[ship_qty]
           ,[total_qty]
           ,[total_num_cartons]
           ,[calc_weight]
           ,[extended_price]
           ,[sales_order_qty]
           ,[units_ordered]
           ,[total_extended_price]
           ,[total_sales_order_qty]
           ,[total_open_ord_qty]
           ,[total_ship_to_date_qty]
           ,[whse_code]
		FROM mpack_order_line
		WHERE mpack_id = @v_mpack_id;
		
		INSERT INTO [dbo].[mpack_order_line_cont_a]
           ([mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[mpack_order_line_cont_seq]
           ,[cont]
           ,[whse_code])
		SELECT 
            [mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[mpack_order_line_cont_seq]
           ,[cont]
           ,[whse_code]
		FROM mpack_order_line_cont 
		WHERE mpack_id = @v_mpack_id;
		
		INSERT INTO [dbo].[mpack_order_line_lot_a]
           ([mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[mpack_order_line_lot_seq]
           ,[lot]
           ,[product_exp_date]
           ,[whse_code]
           ,[ship_qty])
		SELECT 		
			[mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[mpack_order_line_lot_seq]
           ,[lot]
           ,[product_exp_date]
           ,[whse_code]
           ,[ship_qty]
		FROM mpack_order_line_lot 
		WHERE mpack_id = @v_mpack_id;
		
		INSERT INTO [dbo].[mpack_order_line_lot_dsc_a]
           ([whse_code]
           ,[mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[mpack_order_line_lot_seq]
           ,[dsc_reference_id]
           ,[dsc_reference_hist_seq]
           ,[ship_qty])
		SELECT 
            [whse_code]
           ,[mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[mpack_order_line_lot_seq]
           ,[dsc_reference_id]
           ,[dsc_reference_hist_seq]
           ,[ship_qty]
		FROM mpack_order_line_lot_dsc 
		WHERE mpack_id = @v_mpack_id;

		INSERT INTO [dbo].[mpack_order_line_serial_a]
           ([mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[mpack_order_line_serial_seq]
           ,[serial_num]
           ,[whse_code])
		SELECT 	
            [mpack_id]
           ,[mpack_order_seq]
           ,[mpack_order_line_seq]
           ,[mpack_order_line_serial_seq]
           ,[serial_num]
           ,[whse_code]
		FROM mpack_order_line_serial 
		WHERE mpack_id = @v_mpack_id;
		   
		--purge history tables
		
		DELETE FROM mpack_order_line_serial WHERE mpack_id = @v_mpack_id;
		DELETE FROM mpack_order_line_lot_dsc WHERE mpack_id = @v_mpack_id;
		DELETE FROM mpack_order_line_lot WHERE mpack_id = @v_mpack_id;
		DELETE FROM mpack_order_line_cont WHERE mpack_id = @v_mpack_id;
		DELETE FROM mpack_order_line WHERE mpack_id = @v_mpack_id;
		DELETE FROM mpack_order WHERE mpack_id = @v_mpack_id;

		FETCH NEXT FROM cur_mpack INTO @v_mpack_id;
	END
	DELETE FROM mpack WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving mpack Finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving failed for mpack';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  
SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[mpack_a] OFF	

BEGIN TRY
	PRINT N'Archiving shipunit_h Start'
	
	DECLARE @v_shipunit_rid INTEGER	 
	
	DECLARE cur_shipunit CURSOR local forward_only FOR
	SELECT shipunit_rid FROM shipunit_h
	WHERE create_stamp <= @archive_date;				
	
	OPEN cur_shipunit
	FETCH NEXT FROM cur_shipunit INTO @v_shipunit_rid;

	-- start looping
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- start archiving om_h
		PRINT N'Archiving shipunit_h '+ CAST(@v_shipunit_rid AS nvarchar)

--Archive here
		INSERT INTO [dbo].[shipunit_a]
           ([shipunit_rid]
           ,[loc]
           ,[cont]
           ,[sku]
           ,[pkg]
           ,[ob_oid]
           ,[ob_type]
           ,[wave]
           ,[tag]
           ,[curr_inv]
           ,[shipment]
           ,[pams]
           ,[fullskid]
           ,[loaded]
           ,[wgt]
           ,[carrier_service]
           ,[trailer]
           ,[carrier_trailer]
           ,[seal]
           ,[packlist]
           ,[bol]
           ,[manifest]
           ,[probill]
           ,[num_crtn]
           ,[ck_od]
           ,[ck_shipment]
           ,[labeled]
           ,[linehaul_carrier]
           ,[cont_packlist]
           ,[pick_cmp]
           ,[create_stamp]
           ,[dtime_hist]
           ,[num_labels]
           ,[tms_processed]
           ,[tms_tracking_num]
           ,[tms_freight_charge]
           ,[tms_freight_cost]
           ,[tms_shipment_id]
           ,[tms_package_seq]
           ,[freight_class]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[whse_code]
           ,[tms_tracking_barcode]
           ,[create_user]
           ,[mdm_processed]
           ,[is_verified]
           ,[freight_payment_terms_type])
		SELECT
			[shipunit_rid]
           ,[loc]
           ,[cont]
           ,[sku]
           ,[pkg]
           ,[ob_oid]
           ,[ob_type]
           ,[wave]
           ,[tag]
           ,[curr_inv]
           ,[shipment]
           ,[pams]
           ,[fullskid]
           ,[loaded]
           ,[wgt]
           ,[carrier_service]
           ,[trailer]
           ,[carrier_trailer]
           ,[seal]
           ,[packlist]
           ,[bol]
           ,[manifest]
           ,[probill]
           ,[num_crtn]
           ,[ck_od]
           ,[ck_shipment]
           ,[labeled]
           ,[linehaul_carrier]
           ,[cont_packlist]
           ,[pick_cmp]
           ,[create_stamp]
           ,[dtime_hist]
           ,[num_labels]
           ,[tms_processed]
           ,[tms_tracking_num]
           ,[tms_freight_charge]
           ,[tms_freight_cost]
           ,[tms_shipment_id]
           ,[tms_package_seq]
           ,[freight_class]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[whse_code]
           ,[tms_tracking_barcode]
           ,[create_user]
           ,[mdm_processed]
           ,[is_verified]
           ,[freight_payment_terms_type]
		FROM shipunit_h
		WHERE shipunit_rid = @v_shipunit_rid;
		
		INSERT INTO [dbo].[shipunit_a_es]
           ([shipunit_rid]
           ,[whse_code]
           ,[scaled_wgt])
		SELECT 
			[shipunit_rid]
           ,[whse_code]
           ,[scaled_wgt]
		FROM shipunit_h_es a
		WHERE shipunit_rid = @v_shipunit_rid;
	
		DELETE FROM shipunit_h_es WHERE shipunit_rid = @v_shipunit_rid;
				  
		FETCH NEXT FROM cur_shipunit INTO @v_shipunit_rid;
	END
	DELETE FROM shipunit_h WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving shipunit_h finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving failed for shipunit_h.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  

BEGIN TRY
	PRINT N'Archiving om_h Start'
	
	DECLARE @v_ob_oid nvarchar(30)	 
	
	DECLARE cur_om CURSOR local forward_only FOR
	SELECT ob_oid FROM om_h
	WHERE create_stamp <= @archive_date;				
	
	OPEN cur_om
	FETCH NEXT FROM cur_om INTO @v_ob_oid;

	-- start looping
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- start archiving om_h
		PRINT N'Archiving om_h '+ @v_ob_oid

--Archive here

		INSERT INTO [dbo].[om_a]
		   ([om_rid]
		   ,[ob_oid]
		   ,[ob_type]
		   ,[om_class]
		   ,[wave]
		   ,[shipment]
		   ,[grp1]
		   ,[grp2]
		   ,[grp3]
		   ,[ob_ord_stt]
		   ,[dest]
		   ,[search]
		   ,[trailer]
		   ,[stop_seq]
		   ,[mod_resource]
		   ,[mod_user]
		   ,[pams]
		   ,[ship_label_format]
		   ,[request_date]
		   ,[pri]
		   ,[ord_date]
		   ,[sched_date]
		   ,[volume]
		   ,[total_wgt]
		   ,[carrier_service]
		   ,[probill]
		   ,[ship_date]
		   ,[fr_terms]
		   ,[last_lno]
		   ,[demand_ord]
		   ,[bill_po]
		   ,[bill_name]
		   ,[bill_addr1]
		   ,[bill_addr2]
		   ,[bill_addr3]
		   ,[bill_city]
		   ,[bill_state]
		   ,[bill_zip]
		   ,[bill_cntry]
		   ,[bill_custnum]
		   ,[bill_phone]
		   ,[ship_po]
		   ,[ship_name]
		   ,[ship_addr1]
		   ,[ship_addr2]
		   ,[ship_addr3]
		   ,[ship_city]
		   ,[ship_state]
		   ,[ship_zip]
		   ,[ship_cntry]
		   ,[ship_custnum]
		   ,[ship_phone]
		   ,[mod_counter]
		   ,[num_line]
		   ,[special]
		   ,[create_stamp]
		   ,[mod_stamp]
		   ,[export]
		   ,[invoice_num]
		   ,[emergency]
		   ,[ups_consign]
		   ,[fr_chg1]
		   ,[fr_code1]
		   ,[total_value]
		   ,[cont_fmt]
		   ,[is_asn_required]
		   ,[ship_complete]
		   ,[payment_method]
		   ,[pre_auth_exp_date]
		   ,[cc_auth_sw]
		   ,[cancel_by_date]
		   ,[route_code]
		   ,[route_name]
		   ,[transfer_num]
		   ,[bo_num]
		   ,[org_code]
		   ,[div_code]
		   ,[order_num]
		   ,[dtime_hist]
		   ,[language]
		   ,[pick_lbl_fmt]
		   ,[parallel_pick]
		   ,[release_hold_date]
		   ,[freight_payment_terms_type]
		   ,[is_host_maintained]
		   ,[store_num]
		   ,[dept_num]
		   ,[bill_custnum_gln]
		   ,[ship_custnum_gln]
		   ,[custom_char_1]
		   ,[custom_char_2]
		   ,[custom_char_3]
		   ,[custom_char_4]
		   ,[custom_char_5]
		   ,[custom_char_6]
		   ,[custom_char_7]
		   ,[custom_char_8]
		   ,[custom_char_9]
		   ,[custom_char_10]
		   ,[custom_numeric_1]
		   ,[custom_numeric_2]
		   ,[custom_numeric_3]
		   ,[custom_numeric_4]
		   ,[custom_numeric_5]
		   ,[custom_numeric_6]
		   ,[custom_numeric_7]
		   ,[custom_numeric_8]
		   ,[custom_numeric_9]
		   ,[custom_numeric_10]
		   ,[is_cpre_label]
		   ,[ship_label_option]
		   ,[carrier_label_option]
		   ,[wms_ord_create_stamp]
		   ,[whse_code]
		   ,[create_user]
		   ,[store_name]
		   ,[dept_desc]
		   ,[trading_partner_promo_name]
		   ,[trading_partner_vendor_code]
		   ,[trading_partner_cust_po_num]
		   ,[pool_location_code]
		   ,[is_dscsa]
		   ,[external_reference]
		   ,[order_fulfill_type_code]
		   ,[pick_verification_level]
		   ,[pick_command_label_format]
		   ,[appoint_date]
		   ,[appoint_time]
		   ,[appoint_door]
		   ,[label_char_1]
		   ,[label_char_2]
		   ,[label_char_3]
		   ,[label_char_4]
		   ,[label_char_5]
		   ,[label_char_6]
		   ,[label_char_7]
		   ,[label_char_8]
		   ,[label_char_9]
		   ,[label_char_10]
		   ,[is_allow_expired_products])
		SELECT 
			[om_rid]
		   ,[ob_oid]
		   ,[ob_type]
		   ,[om_class]
		   ,[wave]
		   ,[shipment]
		   ,[grp1]
		   ,[grp2]
		   ,[grp3]
		   ,[ob_ord_stt]
		   ,[dest]
		   ,[search]
		   ,[trailer]
		   ,[stop_seq]
		   ,[mod_resource]
		   ,[mod_user]
		   ,[pams]
		   ,[ship_label_format]
		   ,[request_date]
		   ,[pri]
		   ,[ord_date]
		   ,[sched_date]
		   ,[volume]
		   ,[total_wgt]
		   ,[carrier_service]
		   ,[probill]
		   ,[ship_date]
		   ,[fr_terms]
		   ,[last_lno]
		   ,[demand_ord]
		   ,[bill_po]
		   ,[bill_name]
		   ,[bill_addr1]
		   ,[bill_addr2]
		   ,[bill_addr3]
		   ,[bill_city]
		   ,[bill_state]
		   ,[bill_zip]
		   ,[bill_cntry]
		   ,[bill_custnum]
		   ,[bill_phone]
		   ,[ship_po]
		   ,[ship_name]
		   ,[ship_addr1]
		   ,[ship_addr2]
		   ,[ship_addr3]
		   ,[ship_city]
		   ,[ship_state]
		   ,[ship_zip]
		   ,[ship_cntry]
		   ,[ship_custnum]
		   ,[ship_phone]
		   ,[mod_counter]
		   ,[num_line]
		   ,[special]
		   ,[create_stamp]
		   ,[mod_stamp]
		   ,[export]
		   ,[invoice_num]
		   ,[emergency]
		   ,[ups_consign]
		   ,[fr_chg1]
		   ,[fr_code1]
		   ,[total_value]
		   ,[cont_fmt]
		   ,[is_asn_required]
		   ,[ship_complete]
		   ,[payment_method]
		   ,[pre_auth_exp_date]
		   ,[cc_auth_sw]
		   ,[cancel_by_date]
		   ,[route_code]
		   ,[route_name]
		   ,[transfer_num]
		   ,[bo_num]
		   ,[org_code]
		   ,[div_code]
		   ,[order_num]
		   ,[dtime_hist]
		   ,[language]
		   ,[pick_lbl_fmt]
		   ,[parallel_pick]
		   ,[release_hold_date]
		   ,[freight_payment_terms_type]
		   ,[is_host_maintained]
		   ,[store_num]
		   ,[dept_num]
		   ,[bill_custnum_gln]
		   ,[ship_custnum_gln]
		   ,[custom_char_1]
		   ,[custom_char_2]
		   ,[custom_char_3]
		   ,[custom_char_4]
		   ,[custom_char_5]
		   ,[custom_char_6]
		   ,[custom_char_7]
		   ,[custom_char_8]
		   ,[custom_char_9]
		   ,[custom_char_10]
		   ,[custom_numeric_1]
		   ,[custom_numeric_2]
		   ,[custom_numeric_3]
		   ,[custom_numeric_4]
		   ,[custom_numeric_5]
		   ,[custom_numeric_6]
		   ,[custom_numeric_7]
		   ,[custom_numeric_8]
		   ,[custom_numeric_9]
		   ,[custom_numeric_10]
		   ,[is_cpre_label]
		   ,[ship_label_option]
		   ,[carrier_label_option]
		   ,[wms_ord_create_stamp]
		   ,[whse_code]
		   ,[create_user]
		   ,[store_name]
		   ,[dept_desc]
		   ,[trading_partner_promo_name]
		   ,[trading_partner_vendor_code]
		   ,[trading_partner_cust_po_num]
		   ,[pool_location_code]
		   ,[is_dscsa]
		   ,[external_reference]
		   ,[order_fulfill_type_code]
		   ,[pick_verification_level]
		   ,[pick_command_label_format]
		   ,[appoint_date]
		   ,[appoint_time]
		   ,[appoint_door]
		   ,[label_char_1]
		   ,[label_char_2]
		   ,[label_char_3]
		   ,[label_char_4]
		   ,[label_char_5]
		   ,[label_char_6]
		   ,[label_char_7]
		   ,[label_char_8]
		   ,[label_char_9]
		   ,[label_char_10]
		   ,[is_allow_expired_products]
		FROM om_h
		WHERE ob_oid = @v_ob_oid;
		
		
		INSERT INTO [dbo].[od_a]
		   ([od_rid]
		   ,[ob_lno]
		   ,[ob_oid]
		   ,[ob_type]
		   ,[batch_oid]
		   ,[batch_type]
		   ,[batch_lno]
		   ,[ob_lno_stt]
		   ,[sku]
		   ,[pkg]
		   ,[lot]
		   ,[uc1]
		   ,[uc2]
		   ,[uc3]
		   ,[org_qty]
		   ,[ord_qty]
		   ,[plan_qty]
		   ,[bal_plan_qty]
		   ,[bal_cmp_qty]
		   ,[sched_qty]
		   ,[ship_qty]
		   ,[cmp_qty]
		   ,[ord_uom]
		   ,[cust_oid]
		   ,[cust_lno]
		   ,[cust_part]
		   ,[sell_uom]
		   ,[sell_mult]
		   ,[unit_price]
		   ,[hold]
		   ,[fill_short]
		   ,[tag]
		   ,[cont]
		   ,[mod_resource]
		   ,[mod_user]
		   ,[mod_counter]
		   ,[create_stamp]
		   ,[mod_stamp]
		   ,[force_rpln]
		   ,[host_backordered]
		   ,[reqst_recpt_date]
		   ,[open_ord_qty]
		   ,[ship_to_date_qty]
		   ,[dtime_hist]
		   ,[host_order_lno]
		   ,[is_picked_short]
		   ,[kit_line_type]
		   ,[kit_order_group]
		   ,[kit_comp_mult]
		   ,[kit_end_item_ob_lno]
		   ,[gtin]
		   ,[custom_char_1]
		   ,[custom_char_2]
		   ,[custom_char_3]
		   ,[custom_char_4]
		   ,[custom_char_5]
		   ,[custom_char_6]
		   ,[custom_char_7]
		   ,[custom_char_8]
		   ,[custom_char_9]
		   ,[custom_char_10]
		   ,[custom_numeric_1]
		   ,[custom_numeric_2]
		   ,[custom_numeric_3]
		   ,[custom_numeric_4]
		   ,[custom_numeric_5]
		   ,[custom_numeric_6]
		   ,[custom_numeric_7]
		   ,[custom_numeric_8]
		   ,[custom_numeric_9]
		   ,[custom_numeric_10]
		   ,[return_source]
		   ,[backorder_line_action]
		   ,[whse_code]
		   ,[create_user]
		   ,[sms_supply_order_id]
		   ,[buyer_style_num]
		   ,[color_desc]
		   ,[size_desc]
		   ,[trading_partner_item_desc]
		   ,[original_pkg]
		   ,[original_uc1]
		   ,[original_uc2]
		   ,[original_uc3]
		   ,[external_reference]
		   ,[label_char_1]
		   ,[label_char_2]
		   ,[label_char_3]
		   ,[label_char_4]
		   ,[label_char_5]
		   ,[label_char_6]
		   ,[label_char_7]
		   ,[label_char_8]
		   ,[label_char_9]
		   ,[label_char_10]
		   ,[line_item_desc])
		SELECT 		   
			[od_rid]
		   ,[ob_lno]
		   ,[ob_oid]
		   ,[ob_type]
		   ,[batch_oid]
		   ,[batch_type]
		   ,[batch_lno]
		   ,[ob_lno_stt]
		   ,[sku]
		   ,[pkg]
		   ,[lot]
		   ,[uc1]
		   ,[uc2]
		   ,[uc3]
		   ,[org_qty]
		   ,[ord_qty]
		   ,[plan_qty]
		   ,[bal_plan_qty]
		   ,[bal_cmp_qty]
		   ,[sched_qty]
		   ,[ship_qty]
		   ,[cmp_qty]
		   ,[ord_uom]
		   ,[cust_oid]
		   ,[cust_lno]
		   ,[cust_part]
		   ,[sell_uom]
		   ,[sell_mult]
		   ,[unit_price]
		   ,[hold]
		   ,[fill_short]
		   ,[tag]
		   ,[cont]
		   ,[mod_resource]
		   ,[mod_user]
		   ,[mod_counter]
		   ,[create_stamp]
		   ,[mod_stamp]
		   ,[force_rpln]
		   ,[host_backordered]
		   ,[reqst_recpt_date]
		   ,[open_ord_qty]
		   ,[ship_to_date_qty]
		   ,[dtime_hist]
		   ,[host_order_lno]
		   ,[is_picked_short]
		   ,[kit_line_type]
		   ,[kit_order_group]
		   ,[kit_comp_mult]
		   ,[kit_end_item_ob_lno]
		   ,[gtin]
		   ,[custom_char_1]
		   ,[custom_char_2]
		   ,[custom_char_3]
		   ,[custom_char_4]
		   ,[custom_char_5]
		   ,[custom_char_6]
		   ,[custom_char_7]
		   ,[custom_char_8]
		   ,[custom_char_9]
		   ,[custom_char_10]
		   ,[custom_numeric_1]
		   ,[custom_numeric_2]
		   ,[custom_numeric_3]
		   ,[custom_numeric_4]
		   ,[custom_numeric_5]
		   ,[custom_numeric_6]
		   ,[custom_numeric_7]
		   ,[custom_numeric_8]
		   ,[custom_numeric_9]
		   ,[custom_numeric_10]
		   ,[return_source]
		   ,[backorder_line_action]
		   ,[whse_code]
		   ,[create_user]
		   ,[sms_supply_order_id]
		   ,[buyer_style_num]
		   ,[color_desc]
		   ,[size_desc]
		   ,[trading_partner_item_desc]
		   ,[original_pkg]
		   ,[original_uc1]
		   ,[original_uc2]
		   ,[original_uc3]
		   ,[external_reference]
		   ,[label_char_1]
		   ,[label_char_2]
		   ,[label_char_3]
		   ,[label_char_4]
		   ,[label_char_5]
		   ,[label_char_6]
		   ,[label_char_7]
		   ,[label_char_8]
		   ,[label_char_9]
		   ,[label_char_10]
		   ,[line_item_desc]
		FROM od_h
		WHERE ob_oid = @v_ob_oid;

		DELETE FROM od_h WHERE ob_oid = @v_ob_oid;
		
		FETCH NEXT FROM cur_om INTO @v_ob_oid;
	END
	DELETE FROM om_h WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving om_h finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving failed for om_h.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  

BEGIN TRY
	PRINT N'Archiving ibom_h Start'
	
	DECLARE @v_ib_oid nvarchar(30)	 
	
	DECLARE cur_ibom CURSOR local forward_only FOR
	SELECT ib_oid FROM ibom_h
	WHERE create_stamp <= @archive_date;				
	
	OPEN cur_ibom
	FETCH NEXT FROM cur_ibom INTO @v_ib_oid;

	-- start looping
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- start archiving ibom_h
		PRINT N'Archiving ibom_h '+ @v_ib_oid

--Archive here
		INSERT INTO [dbo].[ibom_a]
           ([ibom_rid]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_ord_stt]
           ,[ord_date]
           ,[recv_date]
           ,[arrival_date]
           ,[total_wgt]
           ,[carrier_service]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[probill]
           ,[supplier]
           ,[supp_num]
           ,[dtime_hist]
           ,[is_final_copy]
           ,[is_host_maintained]
           ,[is_keep_backorder]
           ,[dedicated_ob_oid]
           ,[dedicated_order_status]
           ,[dedicated_order_recv_method]
           ,[supp_gln]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[is_host_planned]
           ,[whse_code]
           ,[create_user]
           ,[is_asn_required]
           ,[is_trusted]
           ,[external_reference])
		SELECT
            [ibom_rid]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_ord_stt]
           ,[ord_date]
           ,[recv_date]
           ,[arrival_date]
           ,[total_wgt]
           ,[carrier_service]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[probill]
           ,[supplier]
           ,[supp_num]
           ,[dtime_hist]
           ,[is_final_copy]
           ,[is_host_maintained]
           ,[is_keep_backorder]
           ,[dedicated_ob_oid]
           ,[dedicated_order_status]
           ,[dedicated_order_recv_method]
           ,[supp_gln]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[is_host_planned]
           ,[whse_code]
           ,[create_user]
           ,[is_asn_required]
           ,[is_trusted]
           ,[external_reference]
		FROM [dbo].[ibom_h]
		WHERE ib_oid = @v_ib_oid;	
	 
		INSERT INTO [dbo].[ibod_a]
           ([ibod_rid]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_lno]
           ,[sku]
           ,[pkg]
           ,[lot]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[ib_lno_stt]
           ,[ord_qty]
           ,[ord_uom]
           ,[cmp_qty]
           ,[hold]
           ,[cont]
           ,[tag]
           ,[complete]
           ,[expect_date]
           ,[dt_mfg]
           ,[rotation_time]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[receipt]
           ,[dms_rcvr_line_seq]
           ,[reference_num]
           ,[dtime_hist]
           ,[is_final_copy]
           ,[host_order_lno]
           ,[dedicated_ob_oid]
           ,[dedicated_ob_lno]
           ,[gtin]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[whse_ref]
           ,[whse_code]
           ,[create_user]
           ,[purch_uom]
           ,[purch_mult])
		SELECT 
            [ibod_rid]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_lno]
           ,[sku]
           ,[pkg]
           ,[lot]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[ib_lno_stt]
           ,[ord_qty]
           ,[ord_uom]
           ,[cmp_qty]
           ,[hold]
           ,[cont]
           ,[tag]
           ,[complete]
           ,[expect_date]
           ,[dt_mfg]
           ,[rotation_time]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[receipt]
           ,[dms_rcvr_line_seq]
           ,[reference_num]
           ,[dtime_hist]
           ,[is_final_copy]
           ,[host_order_lno]
           ,[dedicated_ob_oid]
           ,[dedicated_ob_lno]
           ,[gtin]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[whse_ref]
           ,[whse_code]
           ,[create_user]
           ,[purch_uom]
           ,[purch_mult]
		FROM [dbo].[ibod_h]
		WHERE ib_oid = @v_ib_oid;	
	 
		DELETE FROM ibod_h WHERE ib_oid = @v_ib_oid;
		
		FETCH NEXT FROM cur_ibom INTO @v_ib_oid;
	END
	DELETE FROM ibom_h WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving ibom_h finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving failed for ibom_h.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  

BEGIN TRY
	PRINT N'Archiving cp_h Start'
	
	INSERT INTO [dbo].[cp_a]
	   ([cp_rid]
	   ,[task_code]
	   ,[loc]
	   ,[dest]
	   ,[act_loc]
	   ,[final_loc]
	   ,[cmp_stt]
	   ,[cmd_seq]
	   ,[cont]
	   ,[to_cont]
	   ,[sku]
	   ,[pkg]
	   ,[wave]
	   ,[ob_oid]
	   ,[ob_type]
	   ,[od_rid]
	   ,[ob_lno]
	   ,[pri]
	   ,[shipment]
	   ,[pams]
	   ,[grp1]
	   ,[grp2]
	   ,[grp3]
	   ,[curr_inv]
	   ,[dest_inv]
	   ,[act_inv]
	   ,[zone]
	   ,[station]
	   ,[user_name]
	   ,[hold]
	   ,[lot]
	   ,[qty]
	   ,[act_qty]
	   ,[tag]
	   ,[new_tag]
	   ,[uc1]
	   ,[uc2]
	   ,[uc3]
	   ,[cmd_uom]
	   ,[load_factor]
	   ,[wgt]
	   ,[volume]
	   ,[eq_svc]
	   ,[area]
	   ,[src_eq_class]
	   ,[dest_eq_class]
	   ,[list]
	   ,[rsn_code]
	   ,[mobile_cont]
	   ,[num_crtn]
	   ,[mod_resource]
	   ,[mod_user]
	   ,[mod_counter]
	   ,[create_stamp]
	   ,[mod_stamp]
	   ,[cart_act]
	   ,[cart_beg]
	   ,[cart_end]
	   ,[aisle_grp]
	   ,[clust_cont_type]
	   ,[clust]
	   ,[start_time]
	   ,[dtime_hist]
	   ,[input_qty]
	   ,[input_uom]
	   ,[pick_short_rsn]
	   ,[pick_consol_area]
	   ,[is_merge_to_cont]
	   ,[confirm_pickup]
	   ,[to_cntype]
	   ,[org_qty]
	   ,[cycc_oid]
	   ,[whse_code]
	   ,[create_user])
	SELECT  
		[cp_rid]
	   ,[task_code]
	   ,[loc]
	   ,[dest]
	   ,[act_loc]
	   ,[final_loc]
	   ,[cmp_stt]
	   ,[cmd_seq]
	   ,[cont]
	   ,[to_cont]
	   ,[sku]
	   ,[pkg]
	   ,[wave]
	   ,[ob_oid]
	   ,[ob_type]
	   ,[od_rid]
	   ,[ob_lno]
	   ,[pri]
	   ,[shipment]
	   ,[pams]
	   ,[grp1]
	   ,[grp2]
	   ,[grp3]
	   ,[curr_inv]
	   ,[dest_inv]
	   ,[act_inv]
	   ,[zone]
	   ,[station]
	   ,[user_name]
	   ,[hold]
	   ,[lot]
	   ,[qty]
	   ,[act_qty]
	   ,[tag]
	   ,[new_tag]
	   ,[uc1]
	   ,[uc2]
	   ,[uc3]
	   ,[cmd_uom]
	   ,[load_factor]
	   ,[wgt]
	   ,[volume]
	   ,[eq_svc]
	   ,[area]
	   ,[src_eq_class]
	   ,[dest_eq_class]
	   ,[list]
	   ,[rsn_code]
	   ,[mobile_cont]
	   ,[num_crtn]
	   ,[mod_resource]
	   ,[mod_user]
	   ,[mod_counter]
	   ,[create_stamp]
	   ,[mod_stamp]
	   ,[cart_act]
	   ,[cart_beg]
	   ,[cart_end]
	   ,[aisle_grp]
	   ,[clust_cont_type]
	   ,[clust]
	   ,[start_time]
	   ,[dtime_hist]
	   ,[input_qty]
	   ,[input_uom]
	   ,[pick_short_rsn]
	   ,[pick_consol_area]
	   ,[is_merge_to_cont]
	   ,[confirm_pickup]
	   ,[to_cntype]
	   ,[org_qty]
	   ,[cycc_oid]
	   ,[whse_code]
	   ,[create_user]
	FROM cp_h
	WHERE create_stamp <= @archive_date;
		
	DELETE FROM cp_h WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving cp_h Finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving failed for cp_h.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH 


SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[cpack_a] ON	

BEGIN TRY
	PRINT N'Archiving cpack Start'
	
	INSERT INTO [dbo].[cn_h_ldb_a]
	   ([cn_rid]
	   ,[cont]
	   ,[cntype]
	   ,[loc]
	   ,[in_cont]
	   ,[session_app_id]
	   ,[mod_resource]
	   ,[mod_user]
	   ,[mod_counter]
	   ,[create_stamp]
	   ,[mod_stamp]
	   ,[cpre_label]
	   ,[whse_code]
	   ,[create_user])
     SELECT 
		[cn_rid]
	   ,[cont]
	   ,[cntype]
	   ,[loc]
	   ,[in_cont]
	   ,[session_app_id]
	   ,[mod_resource]
	   ,[mod_user]
	   ,[mod_counter]
	   ,[create_stamp]
	   ,[mod_stamp]
	   ,[cpre_label]
	   ,[whse_code]
	   ,[create_user]
	FROM [dbo].[cn_h_ldb]
	WHERE create_stamp <= @archive_date;
	
	DELETE FROM cn_h_ldb WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving cn_h_ldb finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving failed for cn_h_ldb.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  


SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[it_a] ON	

BEGIN TRY
	PRINT N'Archiving it_f Start'
	
	INSERT INTO [dbo].[it_a]
	   ([it_rid]
	   ,[transact]
	   ,[cont]
	   ,[to_cont]
	   ,[sku]
	   ,[pkg]
	   ,[from_loc]
	   ,[to_loc]
	   ,[transact_stt]
	   ,[user_name]
	   ,[lot]
	   ,[uc1]
	   ,[uc2]
	   ,[uc3]
	   ,[wave]
	   ,[ob_oid]
	   ,[ob_type]
	   ,[ib_oid]
	   ,[ib_type]
	   ,[ob_lno]
	   ,[ib_lno]
	   ,[pri]
	   ,[tag]
	   ,[qty]
	   ,[act_qty]
	   ,[carrier_service]
	   ,[trailer]
	   ,[hold]
	   ,[affect_damaged]
	   ,[old_hold]
	   ,[old_affect_damaged]
	   ,[dt_recv]
	   ,[rotation_time]
	   ,[ord_uom]
	   ,[rsn_code]
	   ,[curr_inv]
	   ,[dest_inv]
	   ,[lno_cmp]
	   ,[list]
	   ,[shipment]
	   ,[pams]
	   ,[grp1]
	   ,[grp2]
	   ,[grp3]
	   ,[station]
	   ,[num_crtn]
	   ,[fullskid]
	   ,[bol]
	   ,[manifest]
	   ,[probill]
	   ,[wgt]
	   ,[qty_to_date]
	   ,[linehaul_carrier]
	   ,[mod_resource]
	   ,[mod_user]
	   ,[mod_counter]
	   ,[create_stamp]
	   ,[mod_stamp]
	   ,[seal]
	   ,[carrier_trailer]
	   ,[ser]
	   ,[receipt]
	   ,[supp_num]
	   ,[start_time]
	   ,[end_time]
	   ,[product_exp_date]
	   ,[reference_num]
	   ,[tms_shipment_id]
	   ,[org_code]
	   ,[rma_num]
	   ,[is_from_host]
	   ,[ibret_id]
	   ,[return_line_num]
	   ,[ret_cust_num]
	   ,[goods_rcvd_in_bldg_date]
	   ,[whse_ref]
	   ,[pack_count]
	   ,[confirm_pickup]
	   ,[to_cntype]
	   ,[serial_reference_num]
	   ,[asn_num]
	   ,[quarreason_code]
	   ,[cycc_oid]
	   ,[whse_code]
	   ,[create_user]
	   ,[dest_tag]
	   ,[applied_to_snapshot]
	   ,[is_disassociated_from_order]
	   ,[freight_charge_amt]
	   ,[owner_num]
	   ,[freight_payment_terms_type]
	   ,[use_by_time])
	SELECT 
		[it_rid]
	   ,[transact]
	   ,[cont]
	   ,[to_cont]
	   ,[sku]
	   ,[pkg]
	   ,[from_loc]
	   ,[to_loc]
	   ,[transact_stt]
	   ,[user_name]
	   ,[lot]
	   ,[uc1]
	   ,[uc2]
	   ,[uc3]
	   ,[wave]
	   ,[ob_oid]
	   ,[ob_type]
	   ,[ib_oid]
	   ,[ib_type]
	   ,[ob_lno]
	   ,[ib_lno]
	   ,[pri]
	   ,[tag]
	   ,[qty]
	   ,[act_qty]
	   ,[carrier_service]
	   ,[trailer]
	   ,[hold]
	   ,[affect_damaged]
	   ,[old_hold]
	   ,[old_affect_damaged]
	   ,[dt_recv]
	   ,[rotation_time]
	   ,[ord_uom]
	   ,[rsn_code]
	   ,[curr_inv]
	   ,[dest_inv]
	   ,[lno_cmp]
	   ,[list]
	   ,[shipment]
	   ,[pams]
	   ,[grp1]
	   ,[grp2]
	   ,[grp3]
	   ,[station]
	   ,[num_crtn]
	   ,[fullskid]
	   ,[bol]
	   ,[manifest]
	   ,[probill]
	   ,[wgt]
	   ,[qty_to_date]
	   ,[linehaul_carrier]
	   ,[mod_resource]
	   ,[mod_user]
	   ,[mod_counter]
	   ,[create_stamp]
	   ,[mod_stamp]
	   ,[seal]
	   ,[carrier_trailer]
	   ,[ser]
	   ,[receipt]
	   ,[supp_num]
	   ,[start_time]
	   ,[end_time]
	   ,[product_exp_date]
	   ,[reference_num]
	   ,[tms_shipment_id]
	   ,[org_code]
	   ,[rma_num]
	   ,[is_from_host]
	   ,[ibret_id]
	   ,[return_line_num]
	   ,[ret_cust_num]
	   ,[goods_rcvd_in_bldg_date]
	   ,[whse_ref]
	   ,[pack_count]
	   ,[confirm_pickup]
	   ,[to_cntype]
	   ,[serial_reference_num]
	   ,[asn_num]
	   ,[quarreason_code]
	   ,[cycc_oid]
	   ,[whse_code]
	   ,[create_user]
	   ,[dest_tag]
	   ,[applied_to_snapshot]
	   ,[is_disassociated_from_order]
	   ,[freight_charge_amt]
	   ,[owner_num]
	   ,[freight_payment_terms_type]
	   ,[use_by_time]
	FROM [dbo].[it_f]
	WHERE create_stamp <= @archive_date;
	
	DELETE FROM it_f WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving it_f finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving failed for it_f.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  
SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[it_a] OFF	

BEGIN TRY
	PRINT N'Archiving iv_h Start'
	
	INSERT INTO [dbo].[iv_a]
	   ([iv_rid]
	   ,[tag]
	   ,[loc]
	   ,[cont]
	   ,[ob_oid]
	   ,[ob_type]
	   ,[ob_lno]
	   ,[sku]
	   ,[pkg]
	   ,[hold]
	   ,[rotation_time]
	   ,[cons_date]
	   ,[lot]
	   ,[uc1]
	   ,[uc2]
	   ,[uc3]
	   ,[request_loc]
	   ,[inv_stt]
	   ,[dt_recv]
	   ,[qty]
	   ,[alloc_qty]
	   ,[load_min_qty]
	   ,[load_max_qty]
	   ,[uom1]
	   ,[uom2]
	   ,[uom3]
	   ,[uom4]
	   ,[qty1in2]
	   ,[qty2in3]
	   ,[qty3in4]
	   ,[wgt1]
	   ,[wgt2]
	   ,[wgt3]
	   ,[wgt4]
	   ,[max_stack]
	   ,[hgt1]
	   ,[hgt2]
	   ,[hgt3]
	   ,[hgt4]
	   ,[wid1]
	   ,[wid2]
	   ,[wid3]
	   ,[wid4]
	   ,[dpth1]
	   ,[dpth2]
	   ,[dpth3]
	   ,[dpth4]
	   ,[last_cycc_date]
	   ,[dt_move]
	   ,[intran_qty]
	   ,[load_factor]
	   ,[load_uom]
	   ,[lab_uom]
	   ,[back_uom]
	   ,[brk_uom]
	   ,[cmd_uom]
	   ,[crtn_uom]
	   ,[shipunit_rid]
	   ,[create_stamp]
	   ,[product_exp_date]
	   ,[dtime_hist]
	   ,[host_availability_hold]
	   ,[uom5]
	   ,[uom6]
	   ,[qty4in5]
	   ,[qty5in6]
	   ,[wgt5]
	   ,[wgt6]
	   ,[hgt5]
	   ,[hgt6]
	   ,[wid5]
	   ,[wid6]
	   ,[dpth5]
	   ,[dpth6]
	   ,[whse_code]
	   ,[create_user]
	   ,[dsc_reference_id]
	   ,[use_by_time])
	SELECT
		[iv_rid]
	   ,[tag]
	   ,[loc]
	   ,[cont]
	   ,[ob_oid]
	   ,[ob_type]
	   ,[ob_lno]
	   ,[sku]
	   ,[pkg]
	   ,[hold]
	   ,[rotation_time]
	   ,[cons_date]
	   ,[lot]
	   ,[uc1]
	   ,[uc2]
	   ,[uc3]
	   ,[request_loc]
	   ,[inv_stt]
	   ,[dt_recv]
	   ,[qty]
	   ,[alloc_qty]
	   ,[load_min_qty]
	   ,[load_max_qty]
	   ,[uom1]
	   ,[uom2]
	   ,[uom3]
	   ,[uom4]
	   ,[qty1in2]
	   ,[qty2in3]
	   ,[qty3in4]
	   ,[wgt1]
	   ,[wgt2]
	   ,[wgt3]
	   ,[wgt4]
	   ,[max_stack]
	   ,[hgt1]
	   ,[hgt2]
	   ,[hgt3]
	   ,[hgt4]
	   ,[wid1]
	   ,[wid2]
	   ,[wid3]
	   ,[wid4]
	   ,[dpth1]
	   ,[dpth2]
	   ,[dpth3]
	   ,[dpth4]
	   ,[last_cycc_date]
	   ,[dt_move]
	   ,[intran_qty]
	   ,[load_factor]
	   ,[load_uom]
	   ,[lab_uom]
	   ,[back_uom]
	   ,[brk_uom]
	   ,[cmd_uom]
	   ,[crtn_uom]
	   ,[shipunit_rid]
	   ,[create_stamp]
	   ,[product_exp_date]
	   ,[dtime_hist]
	   ,[host_availability_hold]
	   ,[uom5]
	   ,[uom6]
	   ,[qty4in5]
	   ,[qty5in6]
	   ,[wgt5]
	   ,[wgt6]
	   ,[hgt5]
	   ,[hgt6]
	   ,[wid5]
	   ,[wid6]
	   ,[dpth5]
	   ,[dpth6]
	   ,[whse_code]
	   ,[create_user]
	   ,[dsc_reference_id]
	   ,[use_by_time]
	FROM  [dbo].[iv_h]
	WHERE create_stamp <= @archive_date;
	
	DELETE FROM iv_h WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving iv_h finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving iv_h failed.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  


SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[md_attachment_a] ON	

BEGIN TRY
	PRINT N'Archiving md_attachment Start'
	
	INSERT INTO [dbo].[md_attachment_a]
	   ([attachment_id]
	   ,[database_name]
	   ,[table_name]
	   ,[owner_record]
	   ,[file_name]
	   ,[file_extension]
	   ,[file_content]
	   ,[file_size]
	   ,[file_comment]
	   ,[internet_media_type_code]
	   ,[create_user]
	   ,[create_stamp])
	SELECT 
		[attachment_id]
	   ,[database_name]
	   ,[table_name]
	   ,[owner_record]
	   ,[file_name]
	   ,[file_extension]
	   ,[file_content]
	   ,[file_size]
	   ,[file_comment]
	   ,[internet_media_type_code]
	   ,[create_user]
	   ,[create_stamp]
	FROM [dbo].[md_attachment]
	WHERE create_stamp <= @archive_date;

	DELETE FROM md_attachment WHERE create_stamp < @archive_date;
	
	PRINT N'Archiving md_attachment finish'
	COMMIT;
		
END TRY  

BEGIN CATCH  
    PRINT N'Archiving failed for md_attachment.';
	ROLLBACK;	
	SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
		
	RAISERROR (@ErrorMessage, -- Message text.  
				@ErrorSeverity, -- Severity.  
				@ErrorState -- State.  
				);   
 
END CATCH  
SET IDENTITY_INSERT [int3_94x_w_arch].[dbo].[md_attachment] OFF	


ROLLBACK
SET NOCOUNT OFF
