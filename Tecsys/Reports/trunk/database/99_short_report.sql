SELECT --TOP 10
	CONVERT(DATE, q0.ship_date, 101) ship_date, 	
	COUNT(DISTINCT q0.ship_name) cust_count, 
	COUNT(DISTINCT IIF(short_qty > 0 , q0.ship_name, '')) short_cust_count, 
	COUNT(DISTINCT IIF(q0.delay_in_hrs > 0, q0.ob_oid, '')) delay_order_count,
	COUNT(DISTINCT q0.ob_oid) order_count,
	SUM(q0.ord_cases) sum_ord_cases, 
	SUM(q0.ship_cases) sum_ship_cases, 
	SUM(q0.short_cases) sum_short_cases, 
	SUM(q0.ord_btls) sum_ord_btls, 
	SUM(q0.ship_btls) sum_ship_btls, 
	SUM(q0.short_btls) sum_short_btls
FROM (
	SELECT om_f.ship_date, 
	--CONVERT(varchar,CONVERT(DATE,om_f.ship_date)) +' '+ ISNULL(om_f.appoint_time, '00:00:00') ship_datetime,	
	CONVERT(DATETIME,om_f.ship_date +' '+ ISNULL(om_f.appoint_time, '00:00:00')) expected_ship_datetime,	
	om_f.dtime_hist completed_ship_datetime,
	IIF(DATEDIFF(hour, CONVERT(DATETIME,om_f.ship_date +' '+ ISNULL(om_f.appoint_time, '00:00:00')), om_f.dtime_hist) > 0, 
	DATEDIFF(hour, CONVERT(DATETIME,om_f.ship_date +' '+ ISNULL(om_f.appoint_time, '00:00:00')), om_f.dtime_hist), 0)  delay_in_hrs,
	od_f.ob_oid, om_f.shipment, om_f.wave, 
	om_f.ship_custnum, om_f.ship_name, 
	od_f.sku, pm_f.sku_desc, 
	FLOOR((od_f.ord_qty)/ISNULL(pm_f.custom_numeric_3,1)) ord_cases, 
	FLOOR((od_f.ord_qty)%ISNULL(pm_f.custom_numeric_3,1)) ord_btls, 
	FLOOR((od_f.ship_qty)/ISNULL(pm_f.custom_numeric_3,1)) ship_cases, 
	FLOOR((od_f.ship_qty)%ISNULL(pm_f.custom_numeric_3,1)) ship_btls, 
	FLOOR((od_f.ord_qty - od_f.ship_qty)/ISNULL(pm_f.custom_numeric_3,1)) short_cases, 
	FLOOR((od_f.ord_qty - od_f.ship_qty)%ISNULL(pm_f.custom_numeric_3,1)) short_btls,
	(od_f.ord_qty - od_f.ship_qty) short_qty
	FROM od_h od_f
	INNER JOIN om_h om_f ON om_f.whse_code = od_f.whse_code AND om_f.ob_oid = od_f.ob_oid
	INNER JOIN pm_f ON pm_f.whse_code = od_f.whse_code AND pm_f.sku = od_f.sku
	WHERE om_f.ship_date >= Convert(datetime, '2019-08-01' )
	ORDER BY 1 DESC
) q0	
GROUP BY CONVERT(DATE, q0.ship_date, 101)
ORDER BY 1 DESC

--WHERE (od_f.ord_qty - od_f.ship_qty) > 0;


--select CONVERT(DATETIME,om_f.ship_date +' '+ ISNULL(om_f.appoint_time, '00:00:00')) FROM om_h om_f

