USE [master]
GO

/****** Object:  DdlTrigger [logon_audit_trg]    Script Date: 2019-08-20 2:33:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [logon_audit_trg] 
                ON ALL SERVER
  WITH EXECUTE AS 'tecsys'
                AFTER LOGON 
AS
BEGIN
           
       DECLARE @event_data XML
       DECLARE @status nvarchar(128) 
          DECLARE @status2 nvarchar(128) 
          SET @event_data = EVENTDATA()

       DECLARE @user_spid NVARCHAR(255)
       SET @user_spid = @event_data.value('(/EVENT_INSTANCE/SPID)[1]','nvarchar(255)')
       
       DECLARE @event_time DATE
       SET @event_time = @event_data.value('(/EVENT_INSTANCE/PostTime)[1]','date')
       
       -- Getting the last instance name in the user_env_info
       DECLARE @v_instance_name NVARCHAR(255)
       SELECT @v_instance_name = CONVERT(NVARCHAR(255),SERVERPROPERTY ('InstanceName'))
       IF @v_instance_name IS NULL
             SET @v_instance_name = 'NULL'
             SELECT @status  = CONVERT(NVARCHAR(128), DATABASEPROPERTYEX('tecsys_admin', 'Updateability')) 
                      SELECT @status2 = CONVERT(NVARCHAR(128), DATABASEPROPERTYEX('tecsys_admin', 'Status'))
              IF  @status <> 'READ_ONLY' and @status2 = 'ONLINE'
              BEGIN
       -- Update last connection
       UPDATE  tecsys_admin.dbo.md_audit_db_session   
          SET logoff_type = 2, logoff_stamp = @event_time 
        WHERE  db_session  = @user_spid
                     AND    db_instance_name  = @v_instance_name
                     AND    logoff_stamp IS NULL

       -- Log new connection
       INSERT INTO tecsys_admin.dbo.md_audit_db_session(
       db_user,
       db_session,
       db_instance_name,
       app_host,
       app_ip,
       logon_success,
       logon_stamp,
       logoff_type,
       logoff_stamp)
       VALUES (
       @event_data.value('(/EVENT_INSTANCE/LoginName)[1]','nvarchar(255)'),
       @user_spid, 
       @v_instance_name,
       HOST_NAME(),
       @event_data.value('(/EVENT_INSTANCE/ClientHost)[1]','nvarchar(255)'), 
       1, 
       @event_time, 
       NULL, 
       NULL)
          END
         
END

GO
