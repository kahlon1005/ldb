-- create container packing list

CREATE OR ALTER  PROCEDURE [dbo].[create_cpack_ldb]      
      @whse_code nvarchar(12),
	  @ob_oid    nvarchar(30),
	  @station   char(4),
	  @instance_name nvarchar(80),
	  @gn_num    nvarchar(35) OUTPUT
AS
   DECLARE @cont nvarchar(10), 
	@create_user nvarchar(15) = 'system',
	@mod_counter int = 0,
	@documentTypeName nvarchar(10) = 'CP',
	@gn_type nvarchar(4) = 'CPCK',
	@task_id int;

BEGIN
     
	--loop outbound order conts 
	DECLARE cont_cursor CURSOR local forward_only FOR
		SELECT sh_f.cont FROM shipunit_f sh_f
		INNER JOIN om_f ON om_f.shipment = sh_f.shipment
		WHERE om_f.ob_oid = @ob_oid AND cont <> '';

	OPEN cont_cursor

	FETCH NEXT FROM cont_cursor INTO @cont;

	WHILE @@FETCH_STATUS = 0
	BEGIN 		
		EXEC get_gn_f_doc_num_ldb @whse_code, @gn_type, @gn_num = @gn_num OUTPUT
		
		print @gn_num
		
		--update shipping activity
		UPDATE shipunit_f 
		SET cont_packlist = @gn_num
		WHERE whse_code = @whse_code
		AND cont = @cont;

		if @@rowcount = 0 -- station not found?
		return;
 
	 
		--create container packing record
		INSERT INTO cpack (whse_code, cont_packing_list, station, cont,  is_mult_bill_tos, is_mult_carriers, is_mult_ship_tos, create_stamp, create_user, mod_counter, memo)  
		VALUES (@whse_code, @gn_num, @station, @cont, 0, 0, 0, CURRENT_TIMESTAMP, @create_user, @mod_counter, '');

		EXEC @task_id = ins_mq_warehouse_task_ldb @whse_code, @instance_name, @documentTypeName, @@IDENTITY 			

		UPDATE cpack SET creation_queue_msg_id = @task_id
		WHERE whse_code = @whse_code AND cont_packing_list = @gn_num;				 
	
		FETCH NEXT FROM cont_cursor INTO @cont;		
	END

	CLOSE cont_cursor;
	DEALLOCATE cont_cursor;

END

GO