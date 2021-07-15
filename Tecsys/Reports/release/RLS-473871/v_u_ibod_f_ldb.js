var LDB_UNLOAD_ORDER_SUMMARY_PRINT_VIEW = "WmsVUIbodFLdbSummary2Ldb";

$(document).ready( function() {
	WebTable_initPage();
});

function WebTable_initPage() {
	if (LDB_isUnloadOrderSummaryPrintView()) {
		LDB_doAddCsstoView(LDB_PrintLegalLandscape());
	}
}

function LDB_isUnloadOrderSummaryPrintView() {
	var viewName = $("body").data( "md-view" );
	return (viewName == LDB_UNLOAD_ORDER_SUMMARY_PRINT_VIEW && pageName=="MetaPrintSearch");
}


function LDB_doAddCsstoView(cssCode){
	var styleElement = document.createElement("style");
	styleElement.type = "text/css";
	styleElement.innerText  = cssCode;
	document.head.appendChild(styleElement);
}

function LDB_PrintLegalLandscape(){
	return "@media print {@page { size: legal landscape;}}";
}