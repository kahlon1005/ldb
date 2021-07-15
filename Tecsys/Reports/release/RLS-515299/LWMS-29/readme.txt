## The purpose of this document is to provide the deployment sequence for files under 
##
## LWMS-29 Add column for “Wave” - LDB Shipment Status 

Execute md-tools files in sequence. Click <Load All MD Tables> to execute

1. http://subversion.bcliquor.com/svn/WMS/Reports/trunk/database/12_ddl_view_v_ob_ord_stt_summ_ldb.sql
2. 20.MD-Tool - Column - Load
3. 30.MD-Tool - View - Load