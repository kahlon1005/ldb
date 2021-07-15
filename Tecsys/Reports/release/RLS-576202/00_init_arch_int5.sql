--create objects
USE [master]
GO

IF DB_ID('int5_94x_w_arch') IS NOT NULL
DROP DATABASE int5_94x_w_arch;

--create archive schema
CREATE DATABASE int5_94x_w_arch;
GO

USE [int5_94x_w_arch]
GO

SELECT * INTO om_a FROM [int5_94x_w].[dbo].om_h WHERE 1<>1
SELECT * INTO od_a FROM [int5_94x_w].[dbo].od_h WHERE 1<>1
SELECT * INTO shipunit_a FROM [int5_94x_w].[dbo].shipunit_h WHERE 1<>1
SELECT * INTO shipunit_a_es FROM [int5_94x_w].[dbo].shipunit_h_es WHERE 1<>1
SELECT * INTO bol_a FROM [int5_94x_w].[dbo].bol WHERE 1<>1
SELECT * INTO bol_po_a FROM [int5_94x_w].[dbo].bol_po WHERE 1<>1
SELECT * INTO bol_l_a FROM [int5_94x_w].[dbo].bol_l WHERE 1<>1
SELECT * INTO manifest_a FROM [int5_94x_w].[dbo].manifest WHERE 1<>1
SELECT * INTO manifest_l_a FROM [int5_94x_w].[dbo].manifest_l WHERE 1<>1
SELECT * INTO cpack_a FROM [int5_94x_w].[dbo].cpack WHERE 1<>1
SELECT * INTO cpack_order_a FROM [int5_94x_w].[dbo].cpack_order WHERE 1<>1
SELECT * INTO cpack_order_line_a FROM [int5_94x_w].[dbo].cpack_order_line WHERE 1<>1
SELECT * INTO cpack_order_line_lot_a FROM [int5_94x_w].[dbo].cpack_order_line_lot WHERE 1<>1
SELECT * INTO cpack_order_line_serial_a FROM [int5_94x_w].[dbo].cpack_order_line_serial WHERE 1<>1
SELECT * INTO mpack_a FROM [int5_94x_w].[dbo].mpack WHERE 1<>1
SELECT * INTO mpack_order_a FROM [int5_94x_w].[dbo].mpack_order WHERE 1<>1
SELECT * INTO mpack_order_line_a FROM [int5_94x_w].[dbo].mpack_order_line WHERE 1<>1
SELECT * INTO mpack_order_line_cont_a FROM [int5_94x_w].[dbo].mpack_order_line_cont WHERE 1<>1
SELECT * INTO mpack_order_line_lot_a FROM [int5_94x_w].[dbo].mpack_order_line_lot WHERE 1<>1
SELECT * INTO mpack_order_line_lot_dsc_a FROM [int5_94x_w].[dbo].mpack_order_line_lot_dsc WHERE 1<>1
SELECT * INTO mpack_order_line_serial_a FROM [int5_94x_w].[dbo].mpack_order_line_serial WHERE 1<>1
SELECT * INTO md_attachment_a FROM [int5_94x_w].[dbo].md_attachment WHERE 1<>1
SELECT * INTO iv_a FROM [int5_94x_w].[dbo].iv_h WHERE 1<>1
SELECT * INTO it_a FROM [int5_94x_w].[dbo].it_f WHERE 1<>1
SELECT * INTO cn_h_ldb_a FROM [int5_94x_w].[dbo].cn_h_ldb WHERE 1<>1
SELECT * INTO cp_a FROM [int5_94x_w].[dbo].cp_h WHERE 1<>1
SELECT * INTO ibom_a FROM [int5_94x_w].[dbo].ibom_h WHERE 1<>1
SELECT * INTO ibod_a FROM [int5_94x_w].[dbo].ibod_h WHERE 1<>1

USE [int5_94x_w]
GO
-- create synonyms for archives

IF OBJECT_ID('om_a') IS NULL
BEGIN
	CREATE SYNONYM om_a FOR [int5_94x_w_arch].[dbo].[om_a];
	CREATE SYNONYM od_a FOR [int5_94x_w_arch].[dbo].[od_a];
	CREATE SYNONYM shipunit_a FOR [int5_94x_w_arch].[dbo].[shipunit_a];
	CREATE SYNONYM shipunit_a_es FOR [int5_94x_w_arch].[dbo].[shipunit_a_es];
	CREATE SYNONYM bol_a FOR [int5_94x_w_arch].[dbo].[bol_a];
	CREATE SYNONYM bol_po_a FOR [int5_94x_w_arch].[dbo].[bol_po_a];
	CREATE SYNONYM bol_l_a FOR [int5_94x_w_arch].[dbo].[bol_l_a];
	CREATE SYNONYM manifest_a FOR [int5_94x_w_arch].[dbo].[manifest_a];
	CREATE SYNONYM manifest_l_a FOR [int5_94x_w_arch].[dbo].[manifest_l_a];
	CREATE SYNONYM cpack_a FOR [int5_94x_w_arch].[dbo].[cpack_a];
	CREATE SYNONYM cpack_order_a FOR [int5_94x_w_arch].[dbo].[cpack_order_a];
	CREATE SYNONYM cpack_order_line_a FOR [int5_94x_w_arch].[dbo].[cpack_order_line_a];
	CREATE SYNONYM cpack_order_line_lot_a FOR [int5_94x_w_arch].[dbo].[cpack_order_line_lot_a];
	CREATE SYNONYM cpack_order_line_serial_a FOR [int5_94x_w_arch].[dbo].[cpack_order_line_serial_a];
	CREATE SYNONYM mpack_a FOR [int5_94x_w_arch].[dbo].[mpack_a];
	CREATE SYNONYM mpack_order_a FOR [int5_94x_w_arch].[dbo].[mpack_order_a];
	CREATE SYNONYM mpack_order_line_a FOR [int5_94x_w_arch].[dbo].[mpack_order_line_a];
	CREATE SYNONYM mpack_order_line_cont_a FOR [int5_94x_w_arch].[dbo].[mpack_order_line_cont_a];
	CREATE SYNONYM mpack_order_line_lot_a FOR [int5_94x_w_arch].[dbo].[mpack_order_line_lot_a];
	CREATE SYNONYM mpack_order_line_lot_dsc_a FOR [int5_94x_w_arch].[dbo].[mpack_order_line_lot_dsc_a];
	CREATE SYNONYM mpack_order_line_serial_a FOR [int5_94x_w_arch].[dbo].[mpack_order_line_serial_a];
	CREATE SYNONYM md_attachment_a FOR [int5_94x_w_arch].[dbo].[md_attachment_a];
	CREATE SYNONYM iv_a FOR [int5_94x_w_arch].[dbo].[iv_a];
	CREATE SYNONYM it_a FOR [int5_94x_w_arch].[dbo].[it_a];
	CREATE SYNONYM cn_h_ldb_a FOR [int5_94x_w_arch].[dbo].[cn_h_ldb_a];
	CREATE SYNONYM cp_a FOR [int5_94x_w_arch].[dbo].[cp_a];
	CREATE SYNONYM ibom_a FOR [int5_94x_w_arch].[dbo].[ibom_a];
	CREATE SYNONYM ibod_a FOR [int5_94x_w_arch].[dbo].[ibod_a];
END
GO
-- history and archive view
USE [int5_94x_w]
GO

CREATE OR ALTER VIEW  v_u_om_h AS 
SELECT * FROM om_h
UNION ALL 
SELECT * FROM om_a;
GO

CREATE OR ALTER VIEW  v_u_od_h AS 
SELECT * FROM od_h
UNION ALL 
SELECT * FROM od_a;
GO

CREATE OR ALTER VIEW  v_u_shipunit_h AS 
SELECT * FROM shipunit_h
UNION ALL 
SELECT * FROM shipunit_a;
GO

CREATE OR ALTER VIEW  v_u_shipunit_h_es AS 
SELECT * FROM shipunit_h_es
UNION ALL 
SELECT * FROM shipunit_a_es;
GO

CREATE OR ALTER VIEW  v_u_bol AS 
SELECT * FROM bol
UNION ALL 
SELECT * FROM bol_a;
GO

CREATE OR ALTER VIEW  v_u_bol_po AS 
SELECT * FROM bol_po
UNION ALL 
SELECT * FROM bol_po_a;
GO

CREATE OR ALTER VIEW  v_u_bol_po AS 
SELECT * FROM bol_po
UNION ALL 
SELECT * FROM bol_po_a;
GO

CREATE OR ALTER VIEW  v_u_bol_l AS 
SELECT * FROM bol_l
UNION ALL 
SELECT * FROM bol_l_a;
GO

CREATE OR ALTER VIEW  v_u_manifest AS 
SELECT * FROM manifest
UNION ALL 
SELECT * FROM manifest_a;
GO

CREATE OR ALTER VIEW  v_u_manifest_l AS 
SELECT * FROM manifest_l
UNION ALL 
SELECT * FROM manifest_l_a;
GO

CREATE OR ALTER VIEW  v_u_cpack AS 
SELECT * FROM cpack
UNION ALL 
SELECT * FROM cpack_a;
GO

CREATE OR ALTER VIEW  v_u_cpack_order AS 
SELECT * FROM cpack_order
UNION ALL 
SELECT * FROM cpack_order_a;
GO

CREATE OR ALTER VIEW  v_u_cpack_order_line AS 
SELECT * FROM cpack_order_line
UNION ALL 
SELECT * FROM cpack_order_line_a;
GO

CREATE OR ALTER VIEW  v_u_cpack_order_line_lot AS 
SELECT * FROM cpack_order_line_lot
UNION ALL 
SELECT * FROM cpack_order_line_lot_a;
GO

CREATE OR ALTER VIEW  v_u_cpack_order_line_serial AS 
SELECT * FROM cpack_order_line_serial
UNION ALL 
SELECT * FROM cpack_order_line_serial_a;
GO

CREATE OR ALTER VIEW  v_u_mpack AS 
SELECT * FROM mpack
UNION ALL 
SELECT * FROM mpack_a;
GO

CREATE OR ALTER VIEW v_u_mpack_order AS 
SELECT * FROM mpack_order
UNION ALL 
SELECT * FROM mpack_order_a;
GO

CREATE OR ALTER VIEW v_u_mpack_order_line AS 
SELECT * FROM mpack_order_line
UNION ALL 
SELECT * FROM mpack_order_line_a;
GO

CREATE OR ALTER VIEW v_u_mpack_order_line_cont AS 
SELECT * FROM mpack_order_line_cont
UNION ALL 
SELECT * FROM mpack_order_line_cont_a;
GO

CREATE OR ALTER VIEW v_u_mpack_order_line_lot AS 
SELECT * FROM mpack_order_line_lot
UNION ALL 
SELECT * FROM mpack_order_line_lot_a;
GO

CREATE OR ALTER VIEW v_u_mpack_order_line_lot_dsc AS 
SELECT * FROM mpack_order_line_lot_dsc
UNION ALL 
SELECT * FROM mpack_order_line_lot_dsc_a;
GO

CREATE OR ALTER VIEW v_u_mpack_order_line_serial AS 
SELECT * FROM mpack_order_line_serial
UNION ALL 
SELECT * FROM mpack_order_line_serial_a;
GO

CREATE OR ALTER VIEW v_u_md_attachment AS 
SELECT * FROM md_attachment
UNION ALL 
SELECT * FROM md_attachment_a;
GO

CREATE OR ALTER VIEW v_u_iv_h AS 
SELECT * FROM iv_h
UNION ALL 
SELECT * FROM iv_a;
GO

CREATE OR ALTER VIEW v_u_it_h AS 
SELECT * FROM it_f
UNION ALL 
SELECT * FROM it_a;
GO

CREATE OR ALTER VIEW v_u_cn_h_ldb AS 
SELECT * FROM cn_h_ldb
UNION ALL 
SELECT * FROM cn_h_ldb_a;
GO

CREATE OR ALTER VIEW v_u_cp_h AS 
SELECT * FROM cp_h
UNION ALL 
SELECT * FROM cp_a;
GO

CREATE OR ALTER VIEW v_u_ibom_h AS 
SELECT * FROM ibom_h
UNION ALL 
SELECT * FROM ibom_a;
GO

CREATE OR ALTER VIEW v_u_ibod_h AS 
SELECT * FROM ibod_h
UNION ALL 
SELECT * FROM ibod_a;
GO

INSERT INTO wms_system_properties_ldb (whse_code, property_name, custom_char_01)
VALUES('VDC', 'WMS_ARCHIVE_PERIOD', 3);

