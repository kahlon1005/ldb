--Verify In-Transit quantities for each tag. Any results that are returned should have an in-transit quantity of 0, but do not.

select iv_rid,sku, tag,qty, intran_qty, alloc_Qty
from iv_f
where (intran_qty != 0) and iv_rid not in (select dest_inv from cm_f)
and iv_rid not in (select dest_inv from cp_f);

FIX: update iv_f set intran_qty = 0 where (intran_qty != 0) and iv_rid not in (select dest_inv from cm_f) and iv_rid not in (select dest_inv from cp_f);
(EC) Check onhand quantity for SKU 131873 and 1487

--Verify allocated quantities for each tag. Any results that are returned should have an allocated quantity of 0, but do not.
select iv_rid,sku, tag,qty, intran_qty, alloc_Qty
from iv_f
where (alloc_qty != 0) and iv_rid not in (select curr_inv from cm_f)
and iv_rid not in (select curr_inv from cp_f);

FIX: update iv_f set alloc_qty = 0 where (alloc_qty != 0) and iv_rid not in (select curr_inv from cm_f) and iv_rid not in (select curr_inv from cp_f);
(EC) Check onhand quantity quantity or check any incomplete outbound order.


--Verify that there is no inventory stuck in TRUCK location
select sku, loc, tag, cont, qty, intran_qty,alloc_qty, iv_rid from iv_f
where loc = 'TRUCK' and ob_oid=' ' and cont=' '
and tag not in (select tag from cm_f)
and tag not in (select tag from cp_f);

Details need to be reviewed.  Records should be deleted if there are no associated commands.
(EC) either move the quantity from Truck to location using TECsys move workflow or delete from iv_f if we think that they were shipped out.

--Verify that there are no nonexistent inventory records referenced in commands.
select sku, loc, tag, qty, curr_inv, dest, task_code
from cm_f where curr_inv not in
(select iv_rid from iv_f) and curr_inv <> 0;

Details need to be reviewed.

--One common scenario:
-- curr_inv from cm_f is the iv_f record id. 
-- At the time the wave planning, it found the iv_f record id and it saves the record id to curr_inv in cm_f
-- At the time of releasing the wave, the system cannot find the record id from iv_f and it will return null pointer error message.
-- the wave is then stuck. use sql to update the wave
-- There could be another wave on the same

(EC) there is queue command but the reference to the inventory by record id does not exist.


--UOM mismatches between WMS inventory and WMS part master
select pm_f.sku, pm_f.uom1,iv_f.uom1, pm_f.uom2,iv_f.uom2,
pm_f.uom3,iv_f.uom3, pm_f.uom4,iv_f.uom4
from pm_f, iv_f
where pm_f.sku = iv_f.sku
and pm_f.pkg = iv_f.pkg
and (pm_f.uom1 <> iv_f.uom1 or
pm_f.uom2 <> iv_f.uom2 or
pm_f.uom3 <> iv_f.uom3 or
pm_f.uom4 <> iv_f.uom4);

Details need to be reviewed.

--Validate the empty field in the location Locations that are not empty but marked as empty:
select loc from lc_f where (loc in
(select loc from iv_f) and empty = 'Y') or (loc in
(select loc from cn_f) and empty = 'Y');

FIX: update lc_f set empty = ‘N’ where (loc in (select loc from iv_f) and empty = 'Y') or (loc in (select loc from cn_f) and empty = 'Y');

--Locations that are empty but marked as not empty:
select loc from lc_f where loc not in
(select loc from iv_f) and loc not in
(select loc from cn_f) and empty = 'N';

FIX: update lc_f set empty = ‘Y’ where loc not in (select loc from iv_f) and loc not in (select loc from cn_f) and empty = 'N';


--Verify the cycle count status is valid:
select iv_rid,loc, sku, tag from iv_f
where inv_stt like 'CYC%'
and loc not in
(select loc from cm_f where task_code='CYCC');

FIX: update iv_f set inv_stt = ‘ ‘ where inv_stt like 'CYC%' and loc not in (select loc from cm_f where task_code='CYCC');


--Search for and delete any superfluous waves that have no references in other tables.
select wave from wv_f
where wave not in (select wave from cm_f)
and wave not in (select wave from om_f)
and wave not in (select wave from cp_f)
and wave not in (select wave from ps_f)
and wave not in (select wave from shipunit_f);

FIX: delete from wv_f where wave not in (select wave from cm_f) and wave not in (select wave from om_f) and wave not in (select wave from cp_f) and wave not in (select wave from ps_f) and wave not in (select wave from shipunit_f);


--Validate lc_f to ensure the locations are not set up to overfill  based on replenishment configuration.
select l.loc, p.sku, 
(l.max_fp_cap * 
CASE
 WHEN l.repl_uom = p.uom1 THEN 1
 WHEN l.repl_uom = p.uom2 THEN p.qty1in2
 WHEN l.repl_uom = p.uom3 THEN p.qty2in3 * p.qty1in2
 WHEN l.repl_uom = p.uom4 THEN p.qty3in4 * p.qty2in3 * p.qty1in2
END
) max_fp_capacity, (l.trig_dynam_qty * 
CASE
 WHEN l.trig_uom = p.uom1 THEN 1
 WHEN l.trig_uom = p.uom2 THEN p.qty1in2
 WHEN l.trig_uom = p.uom3 THEN p.qty2in3 * p.qty1in2
 WHEN l.trig_uom = p.uom4 THEN p.qty3in4 * p.qty2in3 * p.qty1in2
END
) ReplenishQty, l.trig_dynam_qty, l.trig_uom, l.repl_dynam_qty, l.repl_uom, p.uom1, p.qty1in2, p.uom2 
FROM lc_f l 
  LEFT JOIN pm_f p 
    ON l.sku = p.sku 
WHERE l.loc_type = 'FP' 
      AND p.sku != 'OPEN' 
      AND ((l.trig_dynam_qty * 
	 CASE
		 WHEN l.trig_uom = p.uom1 THEN 1
		 WHEN l.trig_uom = p.uom2 THEN p.qty1in2
		 WHEN l.trig_uom = p.uom3 THEN p.qty2in3 * p.qty1in2
		 WHEN l.trig_uom = p.uom4 THEN p.qty3in4 * p.qty2in3 * p.qty1in2
	END
	  ) + 
	  (l.repl_dynam_qty * 
	 CASE
		 WHEN l.repl_uom = p.uom1 THEN 1
		 WHEN l.repl_uom = p.uom2 THEN p.qty1in2
		 WHEN l.repl_uom = p.uom3 THEN p.qty2in3 * p.qty1in2
		 WHEN l.repl_uom = p.uom4 THEN p.qty3in4 * p.qty2in3 * p.qty1in2
	END
	  )) > (l.max_fp_cap * 
			CASE
			 WHEN l.repl_uom = p.uom1 THEN 1
			 WHEN l.repl_uom = p.uom2 THEN p.qty1in2
			 WHEN l.repl_uom = p.uom3 THEN p.qty2in3 * p.qty1in2
			 WHEN l.repl_uom = p.uom4 THEN p.qty3in4 * p.qty2in3 * p.qty1in2
			END
			);



--Invalid allocated quantities with commands

select sum(cm_f.qty) cmfqty, iv_f.alloc_qty, iv_f.iv_rid
into alloc_qty_validation1
from iv_f, cm_f
where iv_f.iv_rid = cm_f.curr_inv
group by cm_f.curr_inv, iv_f.alloc_qty, iv_f.iv_rid;

select * into alloc_qty_validation2 from alloc_qty_validation1 where alloc_qty != cmfqty;

select * from alloc_qty_validation2;  --to see the discrepancies

--FIX
	--update iv_f set alloc_qty =
--(select sum(cmfqty) from alloc_qty_validation2 where alloc_qty_validation2.iv_rid = iv_f.iv_rid)
--where iv_rid in
--(select distinct iv_rid from alloc_qty_validation2 where alloc_qty_validation2.iv_rid = iv_f.iv_rid);
--drop table alloc_qty_validation1;
--drop table alloc_qty_validation2;

--Invalid in-transit quantities with commands
select sum(cm_f.qty) cmfqty, iv_f.Intran_qty, iv_f.iv_rid
into intran_qty_validation1
from iv_f, cm_f
where iv_f.iv_rid = cm_f.dest_inv
group by cm_f.dest_inv, iv_f.intran_qty, iv_f.iv_rid;
select * into intran_qty_validation2 from intran_qty_validation1 where intran_qty != cmfqty;
select * from intran_qty_validation2; --to see the discrepancies
FIX: --update iv_f set intran_qty =
--(select sum(cmfqty) from intran_qty_validation2 where intran_qty_validation2.iv_rid = iv_f.iv_rid)
--where iv_rid in
--(select distinct iv_rid from intran_qty_validation2 where intran_qty_validation2.iv_rid = iv_f.iv_rid);
drop table intran_qty_validation1;
drop table intran_qty_validation2;

