USE [msdb]
GO

-- Make sure that email is enabled for agant
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder=1, 
		@databasemail_profile=N'dba_DBMail Public Profile'
GO

-- Configure the job and all related objects
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

-- Creating Operator for email

IF NOT EXISTS (SELECT name FROM dbo.sysoperators WHERE name = N'WMSSupportTeam')
BEGIN

	EXEC msdb.dbo.sp_add_operator @name=N'WMSSupportTeam', 
			@enabled=1, 
			@weekday_pager_start_time=90000, 
			@weekday_pager_end_time=180000, 
			@saturday_pager_start_time=90000, 
			@saturday_pager_end_time=180000, 
			@sunday_pager_start_time=90000, 
			@sunday_pager_end_time=180000, 
			@pager_days=0, 
			@email_address=N'bikram.kahlon@bcldb.com;ldbdba@bcldb.com', 
			@category_name=N'[Uncategorized]'

	IF (@@ERROR <> 0 OR @ReturnCode <> 0)
		RAISERROR('Creating of the operator failed, emails will not be sent', 10,10)
END
ELSE
	RAISERROR('Operator already exists, skipping creating operator', 10,10)

-- Creating category for the job if not exists
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'DBAAdmin' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'DBAAdmin'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

-- Creating a job, if not exists
DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'_dba - Weekly Index Rebuild and Stats', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=3, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'DBAAdmin', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'WMSSupportTeam', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

-- Creating a job Step
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Rebuild Indexes Cnline and Collect Statistics', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @dbname nvarchar(max) --From our cursor.
DECLARE @time_limit_seconds int --How long do we run this for?

--Set our variables
SET @dbname = ''ALL_DATABASES''  
SET @time_limit_seconds = 3600  --By default do not run longer than 1 hour.

Select @time_limit_seconds as ''Run Duration in Seconds''


EXECUTE dbo.IndexOptimize
@Databases = @dbname,
@FragmentationLow = NULL,
@FragmentationMedium = ''INDEX_REBUILD_ONLINE'',  --Don''t take any indexes offline
@FragmentationHigh = ''INDEX_REBUILD_ONLINE'',  --Don''t take any indexes offline
@FragmentationLevel1 = 5,
@FragmentationLevel2 = 25,
@TimeLimit = @time_limit_seconds,
@MinNumberOfPages = 1000, --Don''''t bother with tiny tables.
@UpdateStatistics = ''ALL'',  --Update statistics
@OnlyModifiedStatistics = ''Y'', --Only those who have had thier tables modified recently.
@WaitAtLowPriorityMaxDuration = 2, --Wait only 2 minutes for locks before moving on.
@WaitAtLowPriorityAbortAfterWait = ''SELF'', --If we are waiting for a lock abort and keep going.
@DatabasesInParallel = ''Y''  --Run on multiple databases at once.
', 
		@database_name=N'DBAAdmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Run every Sunday at 2 AM', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190908, 
		@active_end_date=99991231, 
		@active_start_time=20000, 
		@active_end_time=235959, 
		@schedule_uid=N'c65b31c6-a4ec-4720-9cd3-ca52362cdf41'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


