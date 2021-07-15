## The purpose of this document is to provide the deployment sequence for files under 
##
## LWMS-30 LDB Loader’s View – add column for “Last Transaction Date/Time”

1. http://subversion.bcliquor.com/svn/WMS/Reports/trunk/database/11_ddl_view_ob_ord_summ_ldb.sql
2. 10. MD-Tool - Literal - Load
3. 20. MD-Tool - Column - Load
4. 30. MD-Tool - View - Load