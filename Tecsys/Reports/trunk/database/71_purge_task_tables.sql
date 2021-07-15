USE [au_94x_m]
GO

SET XACT_ABORT ON; 

DECLARE 
	@cutoff_date DATETIME = DATEADD(day, -15, GETDATE()),
	@v_task_id   INT;

BEGIN TRY
	WHILE (SELECT TOP 1 1 FROM md_task WHERE create_stamp <= @cutoff_date) > 0 
	BEGIN
		SELECT @v_task_id = task_id FROM md_task WHERE create_stamp <= @cutoff_date;
		
		BEGIN TRANSACTION;
			DELETE FROM md_task_param_join WHERE task_id = @v_task_id;
			DELETE FROM md_task_param WHERE task_id = @v_task_id;
			DELETE FROM md_task_log WHERE task_id = @v_task_id;
			DELETE FROM md_task WHERE task_id = @v_task_id;
		COMMIT TRANSACTION;
	END
END TRY
BEGIN CATCH
	IF (XACT_STATE()) = -1  
	BEGIN  
		PRINT  
			N'The transaction is in an uncommittable state.' +  
			'Rolling back transaction.'  
		ROLLBACK TRANSACTION;  
	END;  
  
	-- Test whether the transaction is committable.  
	IF (XACT_STATE()) = 1  
	BEGIN  
		PRINT  
			N'The transaction is committable.' +  
			'Committing transaction.'  
		COMMIT TRANSACTION;     
	END; 
	
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

