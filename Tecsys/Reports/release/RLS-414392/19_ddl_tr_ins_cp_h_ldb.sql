-- Execute shipping document printing on last pick completion

CREATE OR ALTER TRIGGER [dbo].[tr_ins_cp_h_ldb] ON dbo.cp_h
AFTER INSERT
AS

BEGIN
	DECLARE 
		@whse_code nvarchar(12),
		@ob_oid nvarchar(30), 
		@shipment nvarchar(10),
		@station char(4),
		@instance_name nvarchar(80),
		@gn_num nvarchar(35),
		@carrier_service nvarchar(20),
		@to_cont nvarchar(40),
		@final_loc char(1)
		
	
	SELECT @ob_oid = ob_oid, @whse_code = whse_code, @final_loc = final_loc, @to_cont = to_cont FROM INSERTED;
	
	IF @final_loc = 'Y' AND NOT EXISTS (SELECT 1 FROM cm_f WHERE whse_code = @whse_code AND ob_oid = @ob_oid)
	BEGIN	
		
		SELECT TOP 1 @shipment = shipment, @carrier_service = carrier_service FROM om_f WHERE whse_code = @whse_code AND ob_oid = @ob_oid;
		
		SELECT @instance_name = custom_char_01 FROM wms_system_properties_ldb WHERE whse_code = @whse_code AND property_name = 'INSTANCE_NAME';
		if @@rowcount = 0 -- instance not found?
			set @instance_name = 'tswmsea.dev.bcldb.com_dev_94x';	
		
		
		SELECT @station = station FROM ca_st_ldb WHERE whse_code = @whse_code AND carrier_service = @carrier_service;
		IF @@rowcount = 0 -- station not found?
		BEGIN
			SELECT @station = custom_char_01 FROM wms_system_properties_ldb WHERE whse_code = @whse_code AND property_name = 'DEFAULT_STATION';
			if @@rowcount = 0 -- station not found?
			set @station = 'BASE';		
		END;	
		
		EXEC create_cpack_ldb @whse_code, @ob_oid, @station, @instance_name, @gn_num output	
		-- PRINT @gn_num
		EXEC create_mpack_ldb @whse_code, @shipment, @station, @instance_name, @gn_num output 
		-- PRINT @gn_num
	END 

END
GO 
