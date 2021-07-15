DROP FUNCTION IF EXISTS [dbo].[mpack_loc_list_ldb]
GO

CREATE   FUNCTION [dbo].[mpack_loc_list_ldb](@p_whse_code nvarchar(12), @p_mpack_id int, @p_mpack_order_seq int)
returns nvarchar(max)
as
begin
declare @p_mpack_loc_list nvarchar(max);

set @p_mpack_loc_list = null;

declare @r_mpack_loc$loc nvarchar(40);

declare c_mpack_loc cursor local forward_only for
select distinct(a.loc) from shipunit_f a, iv_f b, v_u_od_f c, mpack_order_line d, mpack_order e
where a.shipunit_rid = b.shipunit_rid
and b.ob_oid = c.ob_oid
and b.ob_type = c.ob_type
and b.ob_lno = c.ob_lno
and c.od_rid = d.od_rid
and d.whse_code = @p_whse_code
and d.mpack_id = @p_mpack_id
and d.mpack_order_seq = @p_mpack_order_seq
order by 1;

    open c_mpack_loc

while 1 = 1
begin
   fetch c_mpack_loc
    into @r_mpack_loc$loc;

   if @@fetch_status = -1
      break;

   if @p_mpack_loc_list is null
      set @p_mpack_loc_list = rtrim(@r_mpack_loc$loc);
    else
      set @p_mpack_loc_list = isnull(@p_mpack_loc_list, '') + isnull(N', ', '') + isnull(rtrim(@r_mpack_loc$loc), '');
end;

close c_mpack_loc;

deallocate c_mpack_loc;

return @p_mpack_loc_list;

end

GO