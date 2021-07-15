USE [msdb]
GO

/****** Object:  Job [_dba - WMS - Abnormal CPU Usage Alert]    Script Date: 9/25/2019 11:08:10 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [DBAAdmin]    Script Date: 9/25/2019 11:08:10 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'DBAAdmin' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'DBAAdmin'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'_dba - WMS - Abnormal CPU Usage Alert', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'DBAAdmin', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [WMSDB - Abnormal CPU Usage]    Script Date: 9/25/2019 11:08:11 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'WMSDB - Abnormal CPU Usage', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'declare @alert_profile varchar(50) = ''dba_DBMail Public Profile''  
declare @alert_recipient_list varchar(150) = ''elena.khramtsova@bcldb.com''
declare @alert_subject varchar(100) =  @@servername + '' WMS Liquor: Abnormal CPU Usage''
declare @alert_body varchar(1000) = ''This message is sent from  SQL Server procedure.''
declare @time_interval integer = 3600
declare @time_to_alert integer = 7 -- This is 7 hours value may be changed

select @time_interval = datediff(second, max(CollectedDT), getdate()) from [DBAAdmin]..[dba_PerformanceStats] where CPU_SQL=0;

if @time_interval > 3600 * @time_to_alert
begin
	set @alert_body = ''CPU usage of '' + @@SERVERNAME + '' did not go down to 0 for over '' 
		+ convert(varchar(10),@time_to_alert) + '' hours. Please, verify WMS environment!''

	EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = @alert_profile
		, @recipients = @alert_recipient_list
		, @body = @alert_body
		, @subject = @alert_subject
		, @importance = ''High''

end', 
		@database_name=N'DBAAdmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Check CPU Usage history', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190925, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'f235171a-a2d5-4ed2-bdad-181144c2268a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


