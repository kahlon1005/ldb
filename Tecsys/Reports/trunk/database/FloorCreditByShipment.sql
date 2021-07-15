declare @ob_oid nvarchar(10) = 1174800,
   @sku nvarchar(10) = 856914,
   @from_ship_date nvarchar(10) = '2019-06-23'


SELECT  
	CASE
		WHEN (d.is_picked_short = 1 AND EXISTS (SELECT 1 FROM it_f WHERE it_f.whse_code = d.whse_code AND it_f.ob_oid = d.ob_oid AND it_f.sku = d.sku AND it_f.ob_lno = d.ob_lno and rsn_code = 'INVENTORY NOT REQUIRED')) THEN 'Short by Picker - INVENTORY NOT REQUIRED'
		WHEN (d.is_picked_short = 1 AND EXISTS (SELECT 1 FROM it_f WHERE it_f.whse_code = d.whse_code AND it_f.ob_oid = d.ob_oid AND it_f.sku = d.sku AND it_f.ob_lno = d.ob_lno and rsn_code = 'INVENTORY UNAVAILABLE')) THEN 'Short by Picker - INVENTORY UNAVAILABLE'
		--WHEN (d.plan_qty = d.sched_qty) THEN 'Not Picked yet'
		WHEN EXISTS (
			select TOP 1 rsn_code from it_f 
			where it_f.whse_code = d.whse_code and it_f.ob_oid = d.ob_oid and it_f.sku = d.sku and rsn_code = 'DISASSOCIATE_ORDER'
		) THEN 'DISASSOCIATE_ORDER'
		WHEN d.plan_qty < d.ord_qty THEN 'Short by Wave Planner'				
	ELSE	
		'UNKNOWN ???'
	END AS "Short Reason",
	--cp_h.pick_short_rsn,
	ISNULL(cp_h.user_name,'') AS "User ID",
	ISNULL(cp_h.loc,'') AS "Location",
	--d.is_picked_short, 
	--h.ob_oid, h.shipment,	
	--MONTH(h.ship_date) AS "Ship Month", 
	IIF(MONTH(h.ship_date) > 3, MONTH(h.ship_date) - 3, MONTH(h.ship_date) + 9) AS "Period", 
	datediff(week, dateadd(week, datediff(week, 0, dateadd(month, datediff(month, 0, h.ship_date), 0)), 0), h.ship_date - 1) + 1 AS "Week",
	--DATEPART(ww,h.ship_date) Ship_Week, 
	CONVERT(varchar,CONVERT(DATE,h.ship_date)) +' '+ ISNULL(h.appoint_time, '00:00:00') AS "Expected Ship Date",
	h.ship_custnum +' '+ h.ship_name AS "Customer Name", 
	IIF(cust_oid = cust_lno, '',cust_oid)  AS "Store #",  
	d.sku AS SKU, p.sku_desc AS "Description", p.custom_char_2 AS "Listing Type", 
	FLOOR(ISNULL(p.custom_numeric_3,1)) AS "Package Size", 
	FLOOR(d.ord_qty) AS "Order Quantity", 
	FLOOR(d.ship_qty) AS "Ship Quantity", 
	FLOOR(d.ord_qty - d.ship_qty) AS "Short Quantity", 	
	d.ord_uom AS UOM,	
	FLOOR(d.ord_qty/ISNULL(p.custom_numeric_3,1)) AS "Order Cases",
	FLOOR(d.ord_qty%ISNULL(p.custom_numeric_3,1)) AS "Order Bottles",	
	--d.plan_qty,	d.cmp_qty,	d.sched_qty,d.ship_qty,	
	FLOOR((d.ord_qty - d.ship_qty)/ISNULL(p.custom_numeric_3,1)) AS "Short Cases", 	
	FLOOR((d.ord_qty - d.ship_qty)%ISNULL(p.custom_numeric_3,1)) AS "Short Bottles", 		
	d.cust_lno AS "Host Order#",
	d.ob_lno AS "Order Line", 
	h.shipment AS "Shipment #",
	--d.host_order_lno,
	h.whse_code AS "Warehouse",
	h.ob_oid AS "Outbound Order"	
FROM v_u_od_f d	
INNER JOIN  v_u_om_f h ON h.whse_code = d.whse_code AND d.ob_oid = h.ob_oid	
INNER JOIN  pm_f p ON  p.whse_code = d.whse_code AND p.sku = d.sku AND p.pkg = REPLACE(d.pkg, '*', '')	
LEFT JOIN cp_h ON cp_h.whse_code = d.whse_code AND cp_h.ob_oid = d.ob_oid AND cp_h.sku = d.sku AND cp_h.ob_lno = d.ob_lno AND pick_short_rsn > 0	
WHERE h.ob_ord_stt = 'SHIP'	AND
  d.ord_qty > d.cmp_qty AND
  h.ship_date >= Convert(datetime, @from_ship_date )
--AND  h.ob_oid = @ob_oid and d.sku = @sku
ORDER BY 6


