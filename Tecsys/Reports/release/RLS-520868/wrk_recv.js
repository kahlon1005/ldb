var WEBTABLE_INBOUND_ORDER_RECEIVING_RF_VIEW = "wms_wrk_recv.wf";
var oldItem = "";
const INPUT_UOM_FIELD = "wms~wrk_recv~input_uom";

function WebTable_initPage() {
	if(!String.prototype.startsWith) {
	  String.prototype.startsWith = function(searchString, position){
		return this.substr(position || 0, searchString.length) === searchString;
	  };
	}	
	MakeInputUomReadOnly();
}

function WebTable_applyOnFocus(currObj) {
	if (WebTable_isInboundOrderReceivingScenario()) {
		var id = columnIdMaps["wms~wrk_recv~sku"];
		var itemObj = $("input[id='"+id+"']")[0];
		var hasFieldChanged = itemObj && (oldItem != itemObj.value);
		if (hasFieldChanged) {
			MetaUtil_setColumnValue(INPUT_UOM_FIELD, "", true);
			WebTable_updateUom(itemObj);
			oldItem = itemObj.value;
		} 	
	} 
}

function WebTable_applyOnFocusOut(obj){
	MakeInputUomReadOnly();
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
    });
}

function WebTable_setUom(data) {
    var resultInfo = data.resultValues_;
	
    if ((resultInfo) && (resultInfo.length > 0)) {
		var caseUom = WebTable_getCaseUom(resultInfo);  
		if (caseUom) MetaUtil_setColumnValue(INPUT_UOM_FIELD, caseUom, true);
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