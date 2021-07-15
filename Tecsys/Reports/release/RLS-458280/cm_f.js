const CONFIRM_AND_COMPLETE_PICK_COMMAND_VIEW = "wms_cm_f.pick_confirm_and_complete_ldb.wf";
const LDB_CONFIRM_PICK_COMMAND_VIEW = "wms_cm_f.pick_confirm.wf_ldb";
const BOTTLE_PICK_AREA = "BOTTLE_PICK_AREA";
const CASE_PICK_AREA = "CASE_PICK_AREA";
const BOTTLE_UOM = "BTL";
const CASE1_UOM = "CASE1";
const PALLET_UOM = "PALLET";
var instructionQty;
var instructionUom;
var isPageConverted;

/*
This function is called when a cm_f related web page is opened, but only processes 
the specified views and pages.

The code converts the inputQty/UOM and pickup instruction depending on the Area, e.g. 
from "Pick 1 CASE12" to "Pick 12 BTL" if the pick command is in a bottle pick area, or 
from "Pick 1 PALLET" to "Pick 24 CASE12" if the pick command is in a case pick area and the location type is FP.

The code makes three AJAX calls to the server:
- call view wms_system_properties_ldb to check if the pick command is in a bottle (or case) pick area.
- call view wms_pm_f.uom_lookup_ldb to get bottles per case, cases per pallet, case uom, etc.
- call view wms_lc_f to check if the location type is FP.

When the user submits a page with an error, e.g. a missing input field, a wrong input UOM, etc., 
WMS pushes the page back with an error message. This is not a page refresh.  It's a new page, and  
the global variables are reset. The values of InputQty/UOM are carried over from the previous page. 
But Pickup Instruction is fetched from the pick command (cm_f) every time, reflecting the original 
InputQty/UOM. For such a page, the JS code converts the pickup instruction and sets the UOM, 
but does not change the carried-over InputQty.

A page is deemed previously converted if: 
- InputQty != the quantity extracted from the pickup instruction, or
- InputUom != the UOM extracted from the pickup instruction.

Assumptions:
- Both WMS views have the pickup_instruction_ldb field.
- pickup_instruction_ldb is in the format of "Pick <qty> <uom>".
*/
function WebTable_initPage() {
	parent.CommonMethods_addHook("post-launchNewWindow", function() {
		parent.CommonMethods_setFocusField();
	});

	if ((LDB_isConfirmAndCompletePick() || LDB_isLdbConfirmPick()) && pageName=="MetaRow") {
		LDB_doPickScreen();
	}
}

function LDB_isConfirmAndCompletePick() {
	return viewName.startsWith(CONFIRM_AND_COMPLETE_PICK_COMMAND_VIEW);
}

function LDB_isLdbConfirmPick() {
	return viewName.startsWith(LDB_CONFIRM_PICK_COMMAND_VIEW);
}

function LDB_doPickScreen() {
	//get page fields:
	var pickInstruction = getColumnValue(columnIdMaps["wms~cm_f~pickup_instruction_ldb"]);
	var sku = getColumnValue(columnIdMaps["wms~cm_f~sku"]);
	var area = getColumnValue(columnIdMaps["wms~cm_f~area"]);
	var location = getColumnValue(columnIdMaps["wms~cm_f~location_instruction"]);
	var inputQty = Number($("input[id='"+columnIdMaps["wms~cm_f~input_qty"]+"']")[0].value);
	var inputUom = $("input[id='"+columnIdMaps["wms~cm_f~input_uom"]+"']")[0].value;
	
	LDB_parsePickupInstruction(pickInstruction, inputQty, inputUom);

	if (instructionUom.startsWith("CASE") && instructionUom!=CASE1_UOM) {
		//check if command is in bottle pick area:
		var url = CommonMethods_getSessionVariable("metaEngineUrl_") + 
			"?resourceName=wms_system_properties_ldb&mode=lookup&format=json" + 
			"&criteria=whse_code/%7BSESSION.WMS_WAREHOUSE%7D" +
			"&criteria=property_name/" + BOTTLE_PICK_AREA + 
			"&criteria=custom_char_01/" + area;	
		Base.Util.Ajax.getJSON(url, function(data) {
			var result = data.resultValues_;
			if (result && result[0] && result[0].columnValues_[2].value_ == area) {
				//command is in bottle pick area.
				LDB_doBottlePick(sku, instructionQty);
			}
		});
	} else if (instructionUom == PALLET_UOM) {
		//check if command is in case pick area:
		var url = CommonMethods_getSessionVariable("metaEngineUrl_") + 
			"?resourceName=wms_system_properties_ldb&mode=lookup&format=json" + 
			"&criteria=whse_code/%7BSESSION.WMS_WAREHOUSE%7D" +
			"&criteria=property_name/" + CASE_PICK_AREA + 
			"&criteria=custom_char_01/" + area;	
		Base.Util.Ajax.getJSON(url, function(data) {
			var result = data.resultValues_;
			if (result && result[0] && result[0].columnValues_[2].value_ == area) {
				//command is in case pick area.
				//check if location type is FP:
				var url = CommonMethods_getSessionVariable("metaEngineUrl_") + 
					"?resourceName=wms_lc_f&mode=lookup&format=json" + 
					"&criteria=whse_code/%7BSESSION.WMS_WAREHOUSE%7D" +
					"&criteria=loc_type/FP" + 
					"&criteria=loc/" + location;	
				Base.Util.Ajax.getJSON(url, function(data) {
					var result = data.resultValues_;
					if (result && result[0] && result[0].columnValues_[1].value_ == location) {
						//location type is FP.
						LDB_doCasePick(sku, instructionQty);
					}
				});
			}
		});
	}
}

function LDB_parsePickupInstruction(instruction, inputQty, inputUom) {
	var qtyStart = 5;
	var qtyEnd = instruction.indexOf(" ", qtyStart);
	var uomStart = qtyEnd + 1;
	instructionQty = Number(instruction.substring(qtyStart, qtyEnd));
	instructionUom = instruction.substring(uomStart);
	isPageConverted = (inputQty!=instructionQty) || (inputUom!=instructionUom);
}

function LDB_doBottlePick(sku, qty) {
	//get bottles per case for the sku:
	var url = CommonMethods_getSessionVariable("metaEngineUrl_") + 
		"?resourceName=wms_pm_f.uom_lookup_ldb&mode=lookup&format=json" + 
		"&criteria=whse_code/%7BSESSION.WMS_WAREHOUSE%7D" +
		"&criteria=sku/" + sku;
	Base.Util.Ajax.getJSON(url, function(data) {
		var result = data.resultValues_;
		if (result) {
			var btlsPerCase = 0;
			var numCols = result[0].columnValues_.length;
			for (var x=0; x<numCols; x++) {
				if (result[0].columnValues_[x].name_=="bottles_per_case_ldb") {
					btlsPerCase = result[0].columnValues_[x].value_;
					break;
				}
			}
			if (btlsPerCase > 0) {
				LDB_setPageFields(qty*btlsPerCase, BOTTLE_UOM);
			}
		}
	});
}

function LDB_doCasePick(sku, qty) {
	//get item fields for the sku: 
	var url = CommonMethods_getSessionVariable("metaEngineUrl_") + 
		"?resourceName=wms_pm_f.uom_lookup_ldb&mode=lookup&format=json" + 
		"&criteria=whse_code/%7BSESSION.WMS_WAREHOUSE%7D" +
		"&criteria=sku/" + sku;
	Base.Util.Ajax.getJSON(url, function(data) {
		var result = data.resultValues_;
		if (result) {
			var caseUom; var casesPerPallet = 0;
			var numCols = result[0].columnValues_.length;
			for (var x=0; x<numCols; x++) {
				if (result[0].columnValues_[x].name_=="case_uom_ldb") {
					caseUom = result[0].columnValues_[x].value_;
				} else if (result[0].columnValues_[x].name_=="cases_per_pallet_ldb") {
					casesPerPallet = result[0].columnValues_[x].value_;
					break;
				} 
			}
			if (casesPerPallet > 0) {
				LDB_setPageFields(qty*casesPerPallet, caseUom);
			}
		}
	});
}

function LDB_setPageFields(qty, uom) {
	MetaUtil_setColumnValue("wms~cm_f~pickup_instruction_ldb", "Pick "+qty+" "+uom);
	MetaUtil_setColumnValue("wms~cm_f~input_uom", uom, true);
	if (!isPageConverted) {
		MetaUtil_setColumnValue("wms~cm_f~input_qty", qty, true);
	}
}
