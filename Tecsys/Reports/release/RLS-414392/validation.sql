-- validate shipping document by order

declare @ob_oid nvarchar(30) = '862784'
select carrier_service, * from om_f where ob_oid = @ob_oid;
select ob_oid, to_cont, clust , input_qty, * from cm_f where ob_oid = @ob_oid
select ob_oid, to_cont, clust, input_qty, * from cp_h where ob_oid = @ob_oid
select ob_oid, cont, qty, * from iv_f where ob_oid = @ob_oid
select mod_stamp, create_stamp, cont, packlist,cont_packlist, * from shipunit_f where cont in (select cont from iv_f where ob_oid = @ob_oid)
select create_stamp, master_packing_list, * from mpack where master_packing_list in (select packlist from shipunit_f where cont in (select cont from iv_f where ob_oid = @ob_oid))
select create_stamp, * from cpack where cont_packing_list in (select cont_packlist from shipunit_f where cont in (select cont from iv_f where ob_oid = @ob_oid))
