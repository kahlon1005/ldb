CREATE OR ALTER FUNCTION [dbo].[getDateDiff_ldb](@StartDate DATETIME, @EndDate DATETIME)
RETURNS nvarchar(100)
AS
BEGIN

	DECLARE @hours  nvarchar(20),
			@minutes INT

	SET @minutes = 
	(   DATEDIFF(MINUTE, @StartDate, @EndDate)
		- ( DATEDIFF(wk, @StartDate,@EndDate)*(2*24*60)
			-- End on Sunday
			-(CASE WHEN DATEPART(dw, @EndDate)  = 1 THEN 24.0*60-DATEDIFF(minute,CONVERT(date,@EndDate),@EndDate) ELSE 0 END)
			-- Start on Saturday
			-(CASE WHEN DATEPART(dw, @StartDate) = 7 THEN DATEDIFF(minute,CONVERT(date,@StartDate),@StartDate) ELSE 0 END)
			-- End on Saturday
			+(CASE WHEN DATEPART(dw, @EndDate)  = 7 THEN DATEDIFF(minute,CONVERT(date,@EndDate),@EndDate) ELSE 0 END)
			-- Start on Saturday
			+(CASE WHEN DATEPART(dw, @StartDate) = 1 THEN 24.0*60-DATEDIFF(minute,CONVERT(date,@StartDate),@StartDate) ELSE 0 END)
		)
	)

	SET @hours = 
		CASE WHEN @minutes >= 1440 THEN
				(SELECT 
					CAST((@minutes / 1440) AS VARCHAR(2)) + 'd ' +  
					CASE WHEN (@minutes % 1440) > 0 THEN
						RIGHT('00' + CAST((@minutes % 1440) / 60 AS VARCHAR(2)),2) + ':' +
						CASE WHEN (@minutes % 60) > 0 THEN
						RIGHT('00' + CAST((@minutes % 60) AS VARCHAR(2)),2) + ''
					ELSE
						''
						END
					ELSE
						''
				 END)
			 WHEN @minutes >= 60 THEN
				(SELECT 
					RIGHT('00' + CAST((@minutes / 60) AS VARCHAR(2)),2) + ':' +  
					CASE WHEN (@minutes % 60) > 0 THEN
						RIGHT('00' + CAST((@minutes % 60) AS VARCHAR(2)),2) + ''
					ELSE
						''
				END)
		ELSE 
			RIGHT('00' + CAST((@minutes % 60) AS VARCHAR(2)),2) + ''
		END


	RETURN N'' 
		+ RTRIM(CAST(@hours AS nvarchar(12)))
		+ N'';  

END 

GO
