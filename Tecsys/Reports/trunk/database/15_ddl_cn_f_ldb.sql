CREATE TABLE [dbo].[cn_h_ldb](
	[cn_rid] [int] NOT NULL,
	[cont] [nvarchar](40) NOT NULL,
	[cntype] [nvarchar](4) NOT NULL,
	[loc] [nvarchar](10) NOT NULL,
	[in_cont] [nvarchar](40) NOT NULL,
	[session_app_id] [int] NOT NULL,
	[mod_resource] [nvarchar](50) NOT NULL,
	[mod_user] [nvarchar](30) NOT NULL,
	[mod_counter] [int] NOT NULL,
	[create_stamp] [datetime] NOT NULL,
	[mod_stamp] [datetime] NOT NULL,
	[cpre_label] [smallint] NOT NULL,
	[whse_code] [nvarchar](12) NOT NULL,
	[create_user] [nvarchar](30) NOT NULL
) ON [PRIMARY]
GO

CREATE OR ALTER TRIGGER tr_ins_cn_h_ldb ON dbo.cn_f
AFTER DELETE
AS
BEGIN
	INSERT INTO dbo.cn_h_ldb (cn_rid, cont, cntype, loc, in_cont, session_app_id, mod_resource, mod_user, mod_counter, create_stamp, mod_stamp, cpre_label, whse_code, create_user)
	SELECT cn_rid, cont, cntype, loc, in_cont, session_app_id, mod_resource, mod_user, mod_counter, create_stamp, mod_stamp, cpre_label, whse_code, create_user FROM DELETED
	
END
GO 

CREATE OR ALTER  VIEW dbo.v_u_cn_f_ldb
AS
SELECT * FROM cn_f
UNION ALL
SELECT * FROM cn_h_ldb

GO
