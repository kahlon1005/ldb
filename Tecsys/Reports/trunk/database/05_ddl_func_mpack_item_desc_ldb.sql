DROP FUNCTION IF EXISTS [dbo].[mpack_item_desc_ldb]
GO

CREATE FUNCTION [dbo].[mpack_item_desc_ldb](@p_whse_code nvarchar(12), @p_mpack_id int, @p_mpack_order_seq int, @p_cont nvarchar(40))
returns nvarchar(max)
as
begin
declare @p_mpack_item_desc_list nvarchar(max);

set @p_mpack_item_desc_list = null;

declare @r_mpack_desc$desc nvarchar(40);

declare c_mpack_desc cursor local forward_only for
  select a.sku_desc from pm_f a, mpack_order_line b
  where a.whse_code = b.whse_code
  and a.sku = b.sku
  and a.pkg = b.pkg
  and b.whse_code = @p_whse_code
  and b.mpack_id = @p_mpack_id
  and b.mpack_order_seq = @p_mpack_order_seq
  and b.cont = @p_cont
  order by a.sku;

    open c_mpack_desc

while 1 = 1
begin
   fetch c_mpack_desc
    into @r_mpack_desc$desc;

   if @@fetch_status = -1
      break;

   if @p_mpack_item_desc_list is null
      set @p_mpack_item_desc_list = rtrim(@r_mpack_desc$desc);
    else
      set @p_mpack_item_desc_list = isnull(@p_mpack_item_desc_list, '') + isnull(N', ', '') + isnull(rtrim(@r_mpack_desc$desc), '');
end;

close c_mpack_desc;

deallocate c_mpack_desc;

return @p_mpack_item_desc_list;

end

GO