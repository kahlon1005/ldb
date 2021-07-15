
-- this script purge task and related tables before cutoff date.

USE [dev_94x_m]
GO

DECLARE 

	@cutoff_date DATETIME = DateAdd(day, -15, GETDATE()),
	@v_task_id     number(15);

BEGIN

	BEGIN TRY
		
		DECLARE cur_task CURSOR local forward_only FOR
			SELECT task_id FROM md_task
			WHERE create_stamp <= @cutoff_date;

		OPEN cur_task
		FETCH NEXT FROM cur_task INTO @v_task_id, @v_shipment;

		-- start looping
		WHILE @@FETCH_STATUS = 0
		
		BEGIN
		
		--purge task related tables		
		
			DELETE FROM md_task_param_join
			WHERE task_id = @v_task_id;
			
			DELETE FROM md_task_param
			WHERE task_id = @v_task_id;
			
			DELETE FROM md_task_log
			WHERE task_id = @v_task_id;
			
		END;
		
		-- delete all task before cutoff
		
		DELETE FROM md_task
			WHERE create_stamp <= @cutoff_date;
			
		
	END TRY;
	
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT; 
		SELECT   
			@ErrorMessage = ERROR_MESSAGE(),  
			@ErrorSeverity = ERROR_SEVERITY(),  
			@ErrorState = ERROR_STATE();  
		
		RAISERROR (@ErrorMessage, -- Message text.  
				   @ErrorSeverity, -- Severity.  
				   @ErrorState -- State.  
				   );   
	END CATCH;
		
		
	
GO



