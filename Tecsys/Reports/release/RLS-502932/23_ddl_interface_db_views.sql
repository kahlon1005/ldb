USE [prod_94x_w]
GO

-- up_ship_archive;

CREATE OR ALTER VIEW v_u_up_ship AS
SELECT * FROM dbo.up_ship
UNION ALL 
SELECT * FROM dbo.up_ship_archive;
GO


-- up_ship_freight_archive;
CREATE OR ALTER VIEW v_u_up_ship_freight AS
SELECT * FROM dbo.up_ship_freight
UNION ALL 
SELECT * FROM dbo.up_ship_freight_archive;
GO


-- up_rcpt_archive;
CREATE OR ALTER VIEW v_u_up_rcpt AS
SELECT * FROM dbo.up_rcpt
UNION ALL 
SELECT * FROM dbo.up_rcpt_archive;
GO

-- up_rcpt_line_archive;
CREATE OR ALTER VIEW v_u_up_rcpt_line AS
SELECT * FROM dbo.up_rcpt_line
UNION ALL 
SELECT * FROM dbo.up_rcpt_line_archive;
GO

-- up_f_archive;
CREATE OR ALTER VIEW v_u_up_f AS
SELECT * FROM dbo.up_f
UNION ALL 
SELECT * FROM dbo.up_f_archive;
GO

-- up_ship_freight_detail_archive;
CREATE OR ALTER VIEW v_u_up_ship_freight_detail AS
SELECT * FROM dbo.up_ship_freight_detail
UNION ALL 
SELECT * FROM dbo.up_ship_freight_detail_archive;
GO

-- up_ship_line_archive;
CREATE OR ALTER VIEW v_u_up_ship_line AS
SELECT * FROM dbo.up_ship_line
UNION ALL 
SELECT * FROM dbo.up_ship_line_archive;
GO

-- up_ship_line_detail_archive;
CREATE OR ALTER VIEW v_u_up_ship_line_detail AS
SELECT * FROM dbo.up_ship_line_detail
UNION ALL 
SELECT * FROM dbo.up_ship_line_detail_archive;
GO


-- up_rcpt_line_detail_archive;
CREATE OR ALTER VIEW v_u_up_rcpt_line_detail AS
SELECT * FROM dbo.up_rcpt_line_detail
UNION ALL 
SELECT * FROM dbo.up_rcpt_line_detail_archive;
GO
