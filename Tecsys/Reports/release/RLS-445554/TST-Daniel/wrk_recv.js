var WEBTABLE_INBOUND_ORDER_RECEIVING_RF_VIEW = "wms_wrk_recv.wf";

function WebTable_initPage() {
	if(!String.prototype.startsWith) {
	  String.prototype.startsWith = function(searchString, position){
		return this.substr(position || 0, searchString.length) === searchString;
	  };
	}	
}


function WebTable_applyOnFocusOut(currObj) {
	if (WebTable_isInboundOrderReceivingScenario()) {
		if (WebTable_isItemField(currObj)) {
			WebTable_updateUom(currObj);
		}
	} 
}

function WebTable_isInboundOrderReceivingScenario() {
	if (viewName.startsWith(WEBTABLE_INBOUND_ORDER_RECEIVING_RF_VIEW) && pageName=="MetaKeyEntry") {
		return true;
	} 
	
	return false;
}

function WebTable_isItemField(currObj) {
	if (currObj.getAttribute("id") == columnIdMaps["wms~wrk_recv~sku"]) {
		return true;
	}	
	return false;
}

function WebTable_updateUom(currObj) {
	if (currObj.value.length == 0) return;
	var url = CommonMethods_getSessionVariable("metaEngineUrl_") + "?resourceName=wms_pm_f.uom_lookup_ldb&mode=lookup&format=json";
    url += "&criteria=whse_code/%7BSESSION.WMS_WAREHOUSE%7D&criteria=sku/"+currObj.value;	
//	console.log(url);
	
	Base.Util.Ajax.getJSON(url,function(data) {
    	WebTable_setUom(data);
    });
}

function WebTable_setUom(data) {
      var resultInfo = data.resultValues_;

      if (resultInfo) {
		var caseUom = WebTable_getCaseUom(resultInfo);  
		if (caseUom) MetaUtil_setColumnValue("wms~wrk_recv~input_uom", caseUom, true);
	  }
}

function WebTable_getCaseUom(resultInfo) {
	var numCols = resultInfo[0].columnValues_.length;
	
	for (var x=0; x< numCols ; x++) {
	 if (resultInfo[0].columnValues_[x].name_ == "case_uom_ldb") {
		return resultInfo[0].columnValues_[x].value_;
	 }
	}
	return "";
}