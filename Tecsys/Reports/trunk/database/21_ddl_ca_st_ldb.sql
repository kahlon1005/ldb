--DROP TABLE ca_st_ldb;
CREATE TABLE [dbo].[ca_st_ldb](
	[ca_st_rid] [int] IDENTITY(1,1) NOT NULL,	
	[carrier_service] [nvarchar](20) NOT NULL,
	[station] [nvarchar](4) NOT NULL,
	[whse_code] [nvarchar](12) NOT NULL,
	[mod_user] [nvarchar](30) NOT NULL,
	[mod_counter] [int] NOT NULL,
	[create_stamp] [datetime] NOT NULL,
	[mod_stamp] [datetime] NOT NULL,
	[create_user] [nvarchar](30) NOT NULL
  CONSTRAINT [pk01ca_st_ldb] PRIMARY KEY CLUSTERED 
	(
		[whse_code] ASC,
		[carrier_service] ASC
	)
)
GO

ALTER TABLE [dbo].[ca_st_ldb]  WITH CHECK ADD  CONSTRAINT [fk02ca_st_ldb] FOREIGN KEY([whse_code])
REFERENCES [dbo].[so_f] ([whse_code])
GO


INSERT INTO ca_st_ldb(whse_code, carrier_service, station, create_user, mod_user, mod_counter, create_stamp, mod_stamp) 
SELECT whse_code, carrier_service, 'BASE', 'system', 'system',0, getDate(), getDate()  FROM ca_f;
GO
