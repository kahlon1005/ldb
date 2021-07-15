local Item = require 'tecsys.wms.Item'
local ItemAlias = require 'tecsys.wms.ItemAlias'
local StgItem = require 'tecsys.wms.StgItem'
local String=  require 'tecsys.util.StringUtil'
local cubiscan100={}


function cubiscan100.processCubiscanMetricsUpdate(csvData)
   local metrics={}

   for i = 1, #csvData do

      local metricsRecord= createMetrics(csvData,i)

      local ItemAlias =ItemAlias.getItemAliasRecord(metricsRecord.primary,item_alias_view)

      --Look up The Item Record that is related to the Item Alias and then apply the metrics
      for i=1, #ItemAlias do
         
         local sku =ItemAlias[i].Item:nodeText()
         local warehouse =EnvironmentProperties.getVcdWarehouse()--get the warehouse to use from Iguana Tecsys.Properties
         local packg =ItemAlias[i].PackageCode:nodeText()

         local Item =Item.getItemRecord(sku,packg,warehouse,item_view)


         UpdateUomsMetrics(sku,packg,warehouse,metricsRecord,Item,i)  ---LookUp the UOM and then apply the Metrics

         isValid=true

         if isValid == true then
            DatabaseConnection.commit()
            DatabaseConnection.close()
            SoapRequest.wakeUpQueueRequest('wms_stage_in')
         else
            isValid = false
         end
      end
   end

   return metrics
end

function createMetrics(csvData,i)
   local metrics={}
   metrics.primary = csvData[i][1]
   metrics.packType = csvData[i][2]
   metrics.description = csvData[i][3]
   metrics.Length  = csvData[i][4]
   metrics.Width  = csvData[i][5]
   metrics.Height = csvData[i][6]
   metrics.Weight = csvData[i][7]
   metrics.Volume = csvData[i][8]

   return metrics
end


function getUomToUpdate(uom1,uom2,uom3,uom4,uom5,uom6,metricsRecord)
   local uomToUpdate
   local valueOfuomToUpdate
   local packType = string.upper(metricsRecord.packType)
   local len = string.len(packType)

   if packType==string.sub(uom1, 1, len)  then
      uomToUpdate='uom1'
      valueOfuomToUpdate=uom1

   elseif packType==string.sub(uom2, 1, len)  then
      uomToUpdate='uom2'
      valueOfuomToUpdate=uom2
   elseif packType==string.sub(uom3, 1, len)  then
      uomToUpdate='uom3'
      valueOfuomToUpdate=uom3
   elseif packType==string.sub(uom4, 1, len)  then
      uomToUpdate='uom4'
      valueOfuomToUpdate=uom4
   elseif packType==string.sub(uom5, 1, len)  then
      uomToUpdate='uom5'
      valueOfuomToUpdate=uom5
   elseif packType==string.sub(uom6, 1, len)  then
      uomToUpdate='uom6'
      valueOfuomToUpdate=uom5

   end
   return uomToUpdate,valueOfuomToUpdate

end

function UpdateUomsMetrics(sku,packg,warehouse,metricsRecord,Item,i) 

   local uom1= Item[i].Uom1:nodeText()
   local uom2= Item[i].Uom2:nodeText()
   local uom3= Item[i].Uom3:nodeText()
   local uom4= Item[i].Uom4:nodeText()
   local uom5= Item[i].Uom5:nodeText()
   local uom6= Item[i].Uom6:nodeText()
   
   --HN02 (Start)
   local defaultWidthUom1=0.99
   local defaultHeightUom1=0.99
   local defaultDepthUom1=0.99
   local defaultWeightUom1=0.0099
   --HN02 (End)
   
   --HN01 (Start)
   local newDepthUom=121.92
   local newWidthUom=101.6
   local newHeightUom=9999999
   local newWeightUom=9999999
   --HN01 (End)
   
   local uomToUpdate,valueOfuomToUpdate=getUomToUpdate(uom1,uom2,uom3,uom4,uom5,uom6,metricsRecord) ---this call return the UOM that need to be updated with the metrics that are coming from cubiscan

   if (uomToUpdate ~= nil ) then
   --Creates the staging records that will update the metrics on pm_f
   --Whenever the CubiScan interface process UOM2 data, the interface will create a new staging Item records for UOM1 with the following values before sending UOM2 to WMS.
   -- Width: 1
   -- Height: 1
   -- Depth: 1
   -- Weight: 0.1
      
      --HN01 (Start)
      if(uomToUpdate=='uom1') then
         --set UOM2 new dimensions
         StgItem.updateFromCubiscan(sku,packg,warehouse,uom2,newDepthUom,newWidthUom,newHeightUom,newWeightUom,'uom2',uomToUpdate)
      end
      --HN01 (End)
      
      if (uomToUpdate=='uom2') then 
         --set UOM1 default dimensions
         StgItem.updateFromCubiscan(sku,packg,warehouse,uom1,defaultDepthUom1,defaultWidthUom1,defaultHeightUom1,defaultWeightUom1,'uom1',uomToUpdate)
         --set UOM3 new dimensions
         StgItem.updateFromCubiscan(sku,packg,warehouse,uom3,newDepthUom,newWidthUom,newHeightUom,newWeightUom,'uom3',uomToUpdate) --HN01
      end
      
      StgItem.updateFromCubiscan(sku,packg,warehouse,valueOfuomToUpdate,metricsRecord.Length,metricsRecord.Width,metricsRecord.Height,metricsRecord.Weight,uomToUpdate,uomToUpdate) 
      
   end 
end
return cubiscan100