
require 'tecsys.db.QueueMessage'
require 'tecsys.db.DatabaseUtil'
local Staging = require "tecsys.util.Staging"
local Literal = require "tecsys.util.Literal"



local stgItem={}
stgItem.tableName = 'stg_pm_f'

local stgItemView = 'wms_stg_pm_f.cubiscan_es'


local stgItemSchema = dbs.init{filename='tecsys/dbs/wms/stg_pm_f.dbs'}



function stgItem.updateFromCubiscan(item,pkgCode,whse,uom,lenth,width,height,weight,uomCodeNumber,uomToUpdate)
   -- setLive(true)
   local queueGroup = "default"
   local queueMessageId = QueueMessage.createStageIn(Literal.WMS, stgItem.tableName, "wms_stage_in", "system", queueGroup)
   local table, row = DatabaseUtil.getTable(stgItemSchema)
   row.stg_queue_message_id = queueMessageId
   row.stg_view_name = stgItemView
   row.stg_action = Staging.Action.CREATE_OR_UPDATE
   row.stg_status = Staging.Status.READY_FOR_TRANSFER
   row.sku=item
   row.pkg=pkgCode
   row.whse_code=whse

   if uomCodeNumber == uomToUpdate then
         row.custom_numeric_9=1
   end
   
   if uomCodeNumber =='uom1' then
      row.uom1=uom
      row.hgt1=height 
      row.wid1=width
      row.wgt1=weight
      row.dpth1=lenth
   elseif uomCodeNumber =='uom2' then
      row.uom2=uom
      row.hgt2=height
      row.wid2=width
      row.wgt2=weight
      row.dpth2=lenth
   elseif uomCodeNumber =='uom3' then
      row.uom3=uom
      row.hgt3=height
      row.wid3=width
      row.wgt3=weight
      row.dpth3=lenth
   elseif uomCodeNumber =='uom4' then
      row.uom4=uom
      row.hgt4=height
      row.wid4=width
      row.wgt4=weight
      row.dpth4=lenth
   elseif uomCodeNumber =='uom5' then
      row.uom5=uom
      row.hgt5=height
      row.wid5=width
      row.wgt5=weight
      row.dpth5=lenth
    elseif uomCodeNumber =='uom6' then
      row.uom6=uom
      row.hgt6=height
      row.wid6=width
      row.wgt6=weight
      row.dpth6=lenth
   end

   DatabaseUtil.setAuditColumns(Literal.WMS, row)
   DatabaseConnection.merge(Literal.WMS, table, true)
   DatabaseConnection.commit()

end

return stgItem
