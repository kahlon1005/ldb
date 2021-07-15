USE [prod_94x_w]
GO
--create view
CREATE OR ALTER VIEW [dbo].[v_ob_doc_ldb]
AS
SELECT om_f.whse_code, om_f.ob_oid, om_f.carrier_service, ca_f.carrier_code,
	CONVERT(varchar,CONVERT(DATE,om_f.ship_date)) +' '+ ISNULL(om_f.appoint_time, '00:00:00') ship_datetime,
	om_f.wave, om_f.shipment, om_f.ob_ord_stt, sh_f.cont, sh_f.packlist, sh_f.bol, sh_f.manifest, sh_f.cont_packlist,
ship_custnum, ship_name	
from v_u_om_f om_f
INNER JOIN ca_f ON om_f.whse_code = ca_f.whse_code AND om_f.carrier_service = ca_f.carrier_service
LEFT JOIN v_u_shipunit_f_ldb sh_f ON om_f.whse_code = sh_f.whse_code AND om_f.shipment = sh_f.shipment;
GO


USE [prod_94x_m]
GO

--create view
CREATE OR ALTER VIEW [dbo].[v_ob_doc_ldb] AS
SELECT * FROM [prod_94x_w].[dbo].[v_ob_doc_ldb]
GO

--create view bol
CREATE OR ALTER VIEW [dbo].[bol] AS
SELECT * FROM [prod_94x_w].[dbo].[bol]
GO

--create view manifest
CREATE OR ALTER VIEW [dbo].[manifest] AS
SELECT * FROM [prod_94x_w].[dbo].[manifest]
GO

--create view cpack
CREATE OR ALTER VIEW [dbo].[cpack] AS
SELECT * FROM [prod_94x_w].[dbo].[cpack]
GO

--create view mpack
CREATE OR ALTER VIEW [dbo].[mpack] AS
SELECT * FROM [prod_94x_w].[dbo].[mpack]
GO

--rename table
IF (NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
             WHERE TABLE_SCHEMA = 'dbo'
             AND  TABLE_NAME = 'md_attachment_2'))
BEGIN
EXEC sp_rename 'dbo.md_attachment', 'md_attachment_2';
END

GO

--create view
CREATE OR ALTER VIEW [dbo].[md_attachment] AS
SELECT 
	attachment_id,
	'meta' AS [database_name]
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
FROM [prod_94x_w].[dbo].[md_attachment]
GO 

            