USE [au_94x_m]
GO

CREATE OR ALTER VIEW [dbo].[v_wms_us_f] AS 
SELECT * 
FROM au_94x_w.dbo.us_f
GO


--Sandbox enviorment refresh

declare	@target_host_name varchar(100) = 'tswmsea.au.bcldb.com' 
declare @bullzip_device_name varchar(20) = 'Bullzip';
declare	@target_instance_name varchar(100) = 'tswmsea.au.bcldb.com_au_94x'

USE [au_94x_m]

update md_user set password = '3i3u3i3k2S3W' where user_name = 'system';
update md_user set password = '3k3G3C3i3u3i' where user_name = 'tecsys';
update md_user set password = '3k3G3C3m3i3G3g' where user_name = 'tecuser';
update md_user set password = '3q3W3i343G3g3c343i3O343G3i' where user_name = 'wms_erp_si_es';

--disable all other user names
update md_user set is_active = 0 where user_name not in ('system', 'tecsys', 'tecuser', 'wms_erp_si_es', 'IAMAccount');
update md_user set default_printer = null;

--remove licenses
delete md_user_license where user_name not in ('system', 'tecsys', 'tecuser', 'wms_erp_si_es', 'IAMAccount');

--update printer
update md_out_device set device_type = 2, primary_host_name = '', primary_port = '', primary_timeout_value = '', external_name = '' where device_name not in ('null', 'nulllbl');

--create a bullzip device
delete from md_out_device where device_name not in ('null','nulllbl');
insert into md_out_device values(@bullzip_device_name, 'PDF Printing', 3, null, null, getdate(), 'Tecuser', GETDATE(), 'tecuser', 0, @bullzip_device_name,'kdctwmslp1', 2813, 5000, null, null, null);

delete from md_app_cluster_server;
delete from md_app_cluster;
delete from md_app_server where instance_name not in ('tecsys_default', @target_instance_name);

IF (select count(0) from md_app_server where instance_name = @target_instance_name) = 0 
	INSERT INTO md_app_server VALUES(@target_instance_name, @target_host_name,'wms' ,getdate() ,'tecsys', getdate() ,'tecsys',0);

--clear out sessions
TRUNCATE TABLE md_session_app_att;
TRUNCATE TABLE md_session_app_cleanup_att;
delete from    md_session_app_cleanup;
delete from    md_lock;
delete from    md_session_app;
TRUNCATE TABLE md_session_att;
delete from    md_session;

delete from md_mq_generic;

--select * from md_out_device;
--Criteriaset has a circular reference with md_timer.  The timer info has to be removed from criteriaset, then timers modified, then 
--update criteriaset with the new environment information
update md_criteriaset set instance_name = null, timer_name = null where view_name in('meta_md_session.purge', 'meta_md_queue_monitor_ldb');
update md_timer set instance_name = @target_instance_name where instance_name != 'tecsys_default';
update md_criteriaset set instance_name = @target_instance_name, timer_name = 'meta_md_session.purge_system_metaumssessionpurge.task' where view_name = 'meta_md_session.purge';
update md_criteriaset set instance_name = @target_instance_name, timer_name = 'meta_md_queue_monitor_ldb' where view_name = 'meta_md_queue_monitor_ldb';


update md_notification set instance_name = @target_instance_name where instance_name != 'tecsys_default';


USE [au_94x_w]
update mq_warehouse_task set instance_name = @target_instance_name;

--select * from wms_system_properties_ldb where property_name = 'INSTANCE_NAME';

delete from label_req;
delete from mq_warehouse_task;

update st_f set list_prt = 'null', report_prt = 'null', bol_prt = 'null', manifest_prt = 'null', pick_prt = 'null', cont_prt = 'null', pack_prt = 'null';

update station_label_device set document_format_name = 'wms_lbl_pdf_ldb' where document_format_name = 'wms_lbl_ldb';
update station_label_device set document_format_name = 'wms_lbl_so_pdf_ldb' where document_format_name = 'wms_lbl_so_ldb';
update so_f set default_format_name = 'wms_lbl_pdf_ldb';
update station_label_device set device_name = @bullzip_device_name;

update wms_system_properties_ldb set custom_char_01 = @target_instance_name where property_name = 'INSTANCE_NAME';
update wms_system_properties_ldb set custom_char_01 = 'BASE' where property_name = 'DEFAULT_STATION';
update ca_st_ldb set station = 'BASE';





