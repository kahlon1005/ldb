--views created for gabreil to unblock


CREATE OR ALTER VIEW v_u_it_a AS 
SELECT * FROM it_f
UNION ALL 
SELECT * FROM it_a;
GO


-- up_f_archive;
CREATE OR ALTER VIEW v_u_up_a AS
SELECT * FROM dbo.up_f
UNION ALL 
SELECT * FROM dbo.up_f_archive;
GO
