--create objects
USE [master]
GO

IF DB_ID('dev_94x_w_ldb') IS NOT NULL
DROP DATABASE dev_94x_w_ldb;

--create archive schema
CREATE DATABASE dev_94x_w_ldb;
GO

USE [dev_94x_w_ldb]
GO

DROP TABLE wmsutil_log_hdr;
DROP TABLE wmsutil_log_dtls

CREATE TABLE wmsutil_log_hdr(
	wmsutil_hrid int IDENTITY(1,1) NOT NULL,
	incident_num nvarchar(30) NOT NULL,
	transact_type nvarchar(10) NOT NULL,
	transact_num nvarchar(30) NOT NULL,
	error_msg nvarchar(255) NOT NULL,
	whse_code nvarchar(10) NOT NULL,
	create_user nvarchar(30) NOT NULL,
	create_stamp  [datetime] NOT NULL
)
GO

CREATE TABLE wmsutil_log_dtls(
	wmsutil_drid int IDENTITY(1,1) NOT NULL,
	wmsutil_hrid int NOT NULL,
	executed_query nvarchar(255) NOT NULL,
	is_success smallint NOT NULL,
	error_msg nvarchar(255) NOT NULL,
	create_user nvarchar(30) NOT NULL,
	create_stamp  [datetime] NOT NULL
)
GO


USE [dev_94x_w]
GO
-- create synonyms for log
DROP SYNONYM wmsutil_log_hdr;
DROP SYNONYM wmsutil_log_dtls


IF OBJECT_ID('wmsutil_log_hdr') IS NULL
BEGIN
	CREATE SYNONYM wmsutil_log_hdr FOR [dev_94x_w_ldb].[dbo].[wmsutil_log_hdr];
	CREATE SYNONYM wmsutil_log_dtls FOR [dev_94x_w_ldb].[dbo].[wmsutil_log_dtls];
END
GO	
