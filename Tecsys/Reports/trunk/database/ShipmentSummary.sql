declare @ob_oid nvarchar(10) = 1174800,
   @sku nvarchar(10) = 856914,
   @from_ship_date nvarchar(10) = '2019-09-15'

SELECT 
	CONVERT(DATE, q0.ship_date, 101) AS "Ship Date", 	
	IIF(MONTH(q0.ship_date) > 3, MONTH(q0.ship_date) - 3, MONTH(q0.ship_date) + 9) AS "Period", 
	datediff(week, dateadd(week, datediff(week, 0, dateadd(month, datediff(month, 0, q0.ship_date), 0)), 0), q0.ship_date - 1) + 1 AS "Week",
	COUNT(DISTINCT q0.ship_name) AS "Total Customers", 
	COUNT(DISTINCT IIF(short_qty > 0 , q0.ship_name, null)) AS "Customers Shorted", 
	ROUND(CAST(COUNT(DISTINCT IIF(short_qty > 0 , q0.ship_name, null)) AS FLOAT)/COUNT(DISTINCT q0.ship_name) * 100, 0) AS "% Customers Shorted", 	
	COUNT(DISTINCT IIF(q0.delay_in_mins > 0,  q0.ship_name, null)) AS "Customer Delayed",	
	COUNT(DISTINCT IIF(short_qty > 0 , q0.ship_name, IIF(q0.delay_in_mins > 0,  q0.ship_name, null))) AS "Customers Shorted or Delayed", 
	ROUND(CAST(COUNT(DISTINCT IIF(short_qty > 0 , q0.ship_name, IIF(q0.delay_in_mins > 0,  q0.ship_name, null))) AS FLOAT)/COUNT(DISTINCT q0.ship_name) * 100, 0) AS "% Customers Shorted or Delayed", 
	COUNT(DISTINCT IIF(q0.delay_in_mins > 0, q0.ob_oid, null)) AS "Orders Delayed",	
	COUNT(DISTINCT q0.ob_oid) AS "Total Order",
	SUM(q0.ord_cases) AS "Cases Ordered", 
	SUM(q0.ship_cases) AS "Cases Shipped", 
	SUM(q0.ord_cases - q0.ship_cases) AS "Cases Shorted",
	CAST(IIF(SUM(q0.ord_cases) > 0, ROUND(SUM(q0.ord_cases - q0.ship_cases)/SUM(q0.ord_cases) * 100,2),0) AS decimal(6,2)) AS "% Cases Shorted",
	SUM(q0.ord_btls) AS "Bottles Ordered", 
	SUM(q0.ship_btls) AS "Bottles Shipped", 
	SUM(q0.ord_btls - q0.ship_btls) AS "Bottles Shorted",
	CAST(IIF(SUM(q0.ord_btls) > 0, ROUND(SUM(q0.ord_btls - q0.ship_btls)/SUM(q0.ord_btls) * 100,2), 0) AS decimal(6,2)) AS "% Bottles Shorted",
	COUNT(DISTINCT q0.sku) AS "Items Ordered",
	COUNT(DISTINCT (IIF(short_qty > 0 ,q0.sku,null))) AS "Items Shorted",
	COUNT(DISTINCT (IIF(ord_cases > 0 ,q0.sku,null))) AS "Items Ordered in Cases",	
	COUNT(DISTINCT (IIF(ord_btls > 0 ,q0.sku,null))) AS "Items Ordered in Bottles",
	COUNT(DISTINCT (IIF(ord_cases > 0 AND q0.short_qty > 0,q0.sku,null))) AS "Items Shorted in Cases",	
	COUNT(DISTINCT (IIF(ord_btls > 0 AND q0.short_qty > 0 ,q0.sku,null))) AS "Items Shorted in Bottles",
	COUNT(IIF(ord_btls > 0 AND q0.short_qty > 0, q0.odh_rid, null))  AS "Bottle Shorts (line)",
	COUNT(IIF(ord_cases > 0 AND q0.short_qty > 0, q0.odh_rid, null))  AS "Case Short (line)",
	SUM(q0.order_lines) AS "Order Lines",
	SUM(q0.picks) AS "Total Picks"
FROM (
	SELECT od_f.odh_rid, om_f.whse_code, om_f.ship_date, 
	--CONVERT(varchar,CONVERT(DATE,om_f.ship_date)) +' '+ ISNULL(om_f.appoint_time, '00:00:00') ship_datetime,	
	CONVERT(DATETIME,om_f.ship_date +' '+ ISNULL(om_f.appoint_time, '00:00:00')) expected_ship_datetime,	
	(SELECT MAX(dtime_hist) FROM cp_h WHERE cp_h.whse_code = od_f.whse_code AND cp_h.ob_oid = od_f.ob_oid AND cont <> '') actual_ship_datetime,		
	DATEDIFF(minute, CONVERT(DATETIME,om_f.ship_date +' '+ ISNULL(om_f.appoint_time, '00:00:00')), 
		(SELECT MAX(dtime_hist) FROM cp_h WHERE cp_h.whse_code = od_f.whse_code AND cp_h.ob_oid = od_f.ob_oid AND cont <> '')) delay_in_mins, 	
	od_f.ob_oid, om_f.shipment, om_f.wave, 
	om_f.ship_custnum, om_f.ship_name, 
	od_f.sku, pm_f.sku_desc, 
	FLOOR((od_f.ord_qty)/ISNULL(pm_f.custom_numeric_3,1)) ord_cases, 
	FLOOR((od_f.ord_qty)%ISNULL(pm_f.custom_numeric_3,1)) ord_btls, 
	FLOOR((od_f.ship_qty)/ISNULL(pm_f.custom_numeric_3,1)) ship_cases, 
	FLOOR((od_f.ship_qty)%ISNULL(pm_f.custom_numeric_3,1)) ship_btls, 
	(od_f.ord_qty - od_f.ship_qty) short_qty,
	1 AS order_lines,
	(SELECT COUNT(1) FROM cp_h WHERE cp_h.whse_code = od_f.whse_code AND cp_h.ob_oid = od_f.ob_oid AND cp_h.sku = od_f.sku AND cp_h.ob_lno = od_f.ob_lno) AS picks	
	FROM od_h od_f
	INNER JOIN om_h om_f ON om_f.whse_code = od_f.whse_code AND om_f.ob_oid = od_f.ob_oid
	INNER JOIN pm_f ON pm_f.whse_code = od_f.whse_code AND pm_f.sku = od_f.sku
	WHERE om_f.ship_date >= Convert(datetime, @from_ship_date)
) q0	
GROUP BY CONVERT(DATE, q0.ship_date, 101),
IIF(MONTH(q0.ship_date) > 3, MONTH(q0.ship_date) - 3, MONTH(q0.ship_date) + 9),
	datediff(week, dateadd(week, datediff(week, 0, dateadd(month, datediff(month, 0, q0.ship_date), 0)), 0), q0.ship_date - 1) + 1
ORDER BY 1 DESC