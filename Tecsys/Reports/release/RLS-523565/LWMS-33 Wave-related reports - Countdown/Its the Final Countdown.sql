
WITH BlockReplens as (SELECT 
		ord.whse_code,
		ord.wave as 'Wave',
		repl.cmd_stt,
		repl.cm_rid as 'ReplId'
	FROM 
		cm_f ord 
		inner join cm_f repl on 
			ord.loc = repl.dest 
			and ord.whse_code = repl.whse_code
		inner join iv_f on 
			ord.loc = iv_f.loc 
			and ord.whse_code = iv_f.whse_code
	where 
		repl.task_code = 'REPL'
		and ord.task_code = 'PICK' 
		and iv_f.qty < ord.qty
	group by ord.whse_code, ord.wave, repl.cm_rid, repl.cmd_stt, repl.dest),
Replens as (SELECT 
		ord.whse_code,
		ord.wave as 'Wave',
		repl.cmd_stt,
		repl.cm_rid as 'ReplId'
	FROM 
		cm_f ord 
		inner join cm_f repl on 
			ord.loc = repl.dest 
			and ord.whse_code = repl.whse_code
		inner join iv_f on 
			ord.loc = iv_f.loc 
			and ord.whse_code = iv_f.whse_code
	where 
		repl.task_code = 'REPL'
		and ord.task_code = 'PICK' 
	group by ord.whse_code, ord.wave, repl.cm_rid, repl.cmd_stt, repl.dest),
GroupedBlockedReplens as (select 
		whse_code,
		wave, 
		sum(IIF(cmd_stt = 'RDYR', 1, 0)) as rplnRdyBlock,
		sum(IIF(cmd_stt != 'RDYR', 1, 0)) as rplnOtherBlock
	from BlockReplens
	Group by whse_code,wave),
GroupedReplens as (select 
		whse_code,
		wave, 
		sum(IIF(cmd_stt = 'RDYR', 1, 0)) as rplnRdyAll,
		sum(IIF(cmd_stt != 'RDYR', 1, 0)) as rplnOtherAll
	from Replens
	Group by whse_code, wave),
Counts as (select 
		cm_f.whse_code,
		wave,
		sum(IIF(to_cntype not LIKE 'BX%' and lc_f.loc_type not in('SHIP', 'DOOR', 'DR-BTLDSPL') and lc_f.loc not like 'WRAPPER%' and lc_f.loc != 'CNSOLIDATE' ,ceiling(qty/pm_f.qty1in2), 0)) cases_cont,
		sum(IIF(to_cntype LIKE 'BX%' and     lc_f.loc_type not in('SHIP', 'DOOR', 'DR-BTLDSPL') and lc_f.loc not like 'WRAPPER%' and lc_f.loc != 'CNSOLIDATE' ,ceiling(qty/pm_f.qty1in2), 0)) btls_cont
	from cm_F --940 commands
		inner join lc_F on
			lc_f.whse_code = cm_f.whse_code
			and lc_f.loc = cm_f.loc
		Inner Join pm_f on
				pm_f.whse_code = cm_F.whse_code
				and pm_f.sku = cm_F.sku
	where 
		 cm_f.task_code = 'PICK'
	Group by cm_f.whse_code, wave),
--get counts of containers in locations grouped by wave
LocationCounts as (select
		iv_f.whse_code,
		om_f.wave,
		sum(IIF(lc_f.loc_type = 'SHIP', ceiling(qty/pm_f.qty1in2), 0)) 'ShipCases',
		sum(IIF(cn_f.loc LIKE 'WRAPPER%', ceiling(qty/ pm_f.qty1in2), 0)) 'WrapCases',
		sum(IIF(cn_f.loc = 'CNSOLIDATE' OR lc_f.loc = 'DR-BTLDSPL',  ceiling(qty/ pm_f.qty1in2), 0)) 'btldsplCases',
		sum(IIF(lc_f.loc_type = 'DOOR', ceiling(qty/ pm_f.qty1in2), 0)) 'DoorCases',
		sum(ceiling(qty/ pm_f.qty1in2)) 'AllCases'
	from iv_f
		Inner join od_f on 
			od_f.whse_code = iv_f.whse_code 
			and od_f.ob_oid = iv_f.ob_oid
			and od_f.ob_lno = iv_f.ob_lno
		Inner join om_f on
			om_f.whse_code = iv_f.whse_code 
			and om_f.ob_oid = iv_f.ob_oid
		Inner Join pm_f on
			pm_f.whse_code = iv_F.whse_code
			and pm_f.sku = iv_f.sku
		inner join cn_f on
			iv_f.whse_code = cn_F.whse_code
			and cn_f.cont = iv_f.cont
		inner join lc_F on
			lc_f.whse_code = cn_f.whse_code
			and lc_f.loc = cn_f.loc
	Group by iv_f.whse_code, om_f.wave),
--get full wave case qty
CaseCount as(select 
		om_f.whse_code,
		wave,
		format(min(om_f.sched_date), 'yyyy-MM-dd') + ' ' + min(om_f.appoint_time) as 'Min Ship Date Time',
		sum(CEILING(od_f.plan_qty / IIF(pm_f.qty1in2>=1,pm_f.qty1in2,1))) as 'Wave Quantity(Cases)'
	from 
		om_f
		Inner join od_f on 
			od_f.whse_code = om_f.whse_code 		
			and om_f.ob_oid = od_f.ob_oid
		Inner Join pm_f on
			pm_f.whse_code = om_f.whse_code
			and pm_f.sku = od_f.sku 
	group by
		om_f.whse_code, om_f.wave)
--start main query
select 
	wv_f.whse_code,
	wv_f.wave as 'Wave Id', 
	cast(STUFF((	SELECT N'; ' + Carrier_service 
							FROM om_f AS p2
							WHERE p2.wave = wv_f.wave 
							Group by Carrier_service
							ORDER BY Carrier_service
							FOR XML PATH(N'')), 1, 2, N'') as nvarchar(1000)) as 'Wave Desc',
	wv_f.create_stamp as 'Wave Time',
	cc.[Min Ship Date Time],
	cc.[Wave Quantity(Cases)],
	isnull(gbr.rplnRdyBlock,0)						as 'Replen RDYR Blocking (Commands)',
	isnull(gbr.rplnOtherBlock,0)					as 'Replen Other Blocking (Commands)',
	isnull(gr.rplnRdyAll - gbr.rplnRdyBlock,0)		as 'Replen RDYR NoBlock (Commands)',
	isnull(gr.rplnOtherAll - gbr.rplnOtherBlock ,0)	as 'Replen Other NoBlock (Commands)',
	isnull(c.cases_cont,0) as 'Assembly Cases (Cases)',
	isnull(c.btls_cont,0) as 'Assembly Bottles (Cases)',
	isnull(lc.btldsplCases + lc.WrapCases + lc.ShipCases,0) as 'Staged (Cases)',
	isnull(lc.DoorCases,0) as 'Loaded (Cases)',
	isnull(lc.AllCases - (lc.DoorCases + lc.btldsplCases + lc.WrapCases + lc.ShipCases)  ,0) as 'Other (Cases)'
from 
	wv_f
	left join GroupedReplens gr on
		gr.Wave = wv_f.wave and
		gr.whse_code = wv_f.whse_code
	left join GroupedBlockedReplens gbr on
		gbr.Wave = wv_f.wave and
		gbr.whse_code = wv_f.whse_code
	left join counts c on
		c.wave = wv_F.wave and
		c.whse_code = wv_f.whse_code
	left join locationCounts lc on
		lc.wave = wv_F.wave	and
		lc.whse_code = wv_f.whse_code
	left join CaseCount cc on
		cc.wave = wv_F.wave	and
		cc.whse_code = wv_f.whse_code		
where
	wv_f.whse_code ='VDC'
	and wv_f.wave_stt = 'RDY'
Order by 
	wv_f.create_stamp desc 
