//
// This software is unpublished confidential proprietary property and
// is distributed under agreement with Tecsys Incorporated.
// Tecsys Incorporated owns all rights to this work and intends to keep
// this software confidential so as to maintain its value as a trade
// secret.  This software is furnished under a license and may be used,
// copied or disclosed only in accordance with the terms of such license
// and with inclusion of this notice.
//
//              (C)Copyright Tecsys Incorporated, 2005-2012
//

// Custom javascript extension table functions for cm_f

function WebTable_initPage() {

	parent.CommonMethods_addHook("post-launchNewWindow", function() {
		parent.CommonMethods_setFocusField();
	});

}
