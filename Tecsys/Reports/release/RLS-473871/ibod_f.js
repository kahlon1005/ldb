var LDB_INBOUND_ORDER_SUMMARY_PRINT_VIEW = "WmsIbodFSummaryLdb";

$(document).ready( function() {
	WebTable_initPage();
});

function WebTable_initPage() {
	if (LDB_isInboundOrderSummaryPrintView()) {
		LDB_doAddCsstoView(LDB_PrintLegalLandscape());
	}
}

function LDB_isInboundOrderSummaryPrintView() {
	var viewName = $("body").data( "md-view" );
	return (viewName == LDB_INBOUND_ORDER_SUMMARY_PRINT_VIEW && pageName=="MetaPrintSearch");
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