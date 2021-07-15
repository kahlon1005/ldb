-- Current order creation count by hour
select DATEPART(hh,create_stamp) "drop_hour", count(1) order_count from om_f
group by DATEPART(hh,create_stamp)
order by 1 desc; 
