var WEBTABLE_INBOUND_ORDER_RECEIVING_RF_VIEW = "wms_wrk_recv.wf";
const INPUT_SKU_FIELD = "wms~wrk_recv~sku";
const INPUT_UOM_FIELD = "wms~wrk_recv~input_uom";
const INPUT_QTY_FIELD = "wms~wrk_recv~input_qty";

function WebTable_initPage() {
	if(!String.prototype.startsWith) {
	  String.prototype.startsWith = function(searchString, position){
		return this.substr(position || 0, searchString.length) === searchString;
	  };
	}
	MakeInputUomReadOnly();
}

function WebTable_applyOnFocusOut(obj){
    if ((WebTable_isInboundOrderReceivingScenario()) && (columnIdMaps[INPUT_SKU_FIELD] == obj.id)){
		DisableInputQuantity();
		MetaUtil_setColumnValue(INPUT_UOM_FIELD, "", true);
		WebTable_updateUom(obj);
		EnableInputQuantity();
	}
	MakeInputUomReadOnly();
}

function DisableInputQuantity(){
	if (WebTable_isInboundOrderReceivingScenario()) {
		var inputQtyId = columnIdMaps[INPUT_QTY_FIELD];
		if (inputQtyId){
			var inputQty = TUtil_getElement(inputQtyId);
			MetaUtil_setColumnValue(INPUT_QTY_FIELD, "0", false);
			inputQty.disabled = true;
		}
	}
}
function EnableInputQuantity(){
	if (WebTable_isInboundOrderReceivingScenario()) {
		var skuId = columnIdMaps[INPUT_SKU_FIELD];
		if (skuId){
			var SKUInput = TUtil_getElement(skuId);
			if (SKUInput.value.trim() != ""){
				var inputQtyId = columnIdMaps[INPUT_QTY_FIELD];
				if (inputQtyId){
					var inputQty = TUtil_getElement(inputQtyId);
					inputQty.disabled = false;
				}
			}
		}
	}
}
function MakeInputUomReadOnly(){
	if (WebTable_isInboundOrderReceivingScenario()) {
		var UOMId = columnIdMaps[INPUT_UOM_FIELD];
		if (UOMId){
			var UOMInput = TUtil_getElement(UOMId);
			UOMInput.readOnly = true;
			UOMInput.disabled = true;

			var UOMlookup = TUtil_getElement(UOMId + "_lookup_action");
			UOMlookup.style.visibility = "hidden";		
			UOMlookup.disabled = true;
		}
	}
}

function WebTable_isInboundOrderReceivingScenario() {
	if (viewName.startsWith(WEBTABLE_INBOUND_ORDER_RECEIVING_RF_VIEW) && pageName=="MetaKeyEntry") {
		return true;
	} 
	return false;
}

function WebTable_updateUom(itemObj) {
	if (itemObj.value.length == 0) return;
	var url = CommonMethods_getSessionVariable("metaEngineUrl_") + "?resourceName=wms_pm_f.uom_lookup_ldb&mode=lookup&format=json";
    url += "&criteria=whse_code/%7BSESSION.WMS_WAREHOUSE%7D&criteria=sku/"+itemObj.value;	
	
	Base.Util.Ajax.getJSON(url,function(data) {
    	WebTable_setUom(data);
    }, undefined, false);
}

function WebTable_setUom(data) {
    var resultInfo = data.resultValues_;
	
    if ((resultInfo) && (resultInfo.length > 0)) {
		var caseUom = WebTable_getCaseUom(resultInfo);  
		if (caseUom) 
			MetaUtil_setColumnValue(INPUT_UOM_FIELD, caseUom, true);
	}
}

function WebTable_getCaseUom(resultInfo) {
	if (resultInfo.length > 0){
		var numCols = resultInfo[0].columnValues_.length;
		
		for (var x=0; x< numCols ; x++) {
			if (resultInfo[0].columnValues_[x].name_ == "case_uom_ldb") {
				return resultInfo[0].columnValues_[x].value_;
			}
		}
	}
	return "";
}