deployment folder C:\dev\workspace\Reports\release\RLS-414392

Pre-deployment 
------------------------------------------
Setup Output Devices
Setup Stations


Deployment Steps
-------------------------------
Checkout from below svn repo

http://subversion.bcliquor.com/svn/WMS/Reports/release/RLS-414392

1. Execute sql file in wms-liquor sql server database

DEV -  sqlcmd -S tswmsdb.dev.bcldb.com -d dev_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql

INT3 -  sqlcmd -S tswmsdb.int3.bcldb.com -d int3_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql
INT1 -  sqlcmd -S tswmsdb.int1.bcldb.com -d int1_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql
INT5 -  sqlcmd -S tswmsdb.int5.bcldb.com -d int5_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql

2. execute update below 

update  wms_system_properties_ldb
set custom_char_01 ='tswmsea.int1.bcldb.com_int1_94x' 
where whse_code = 'VDC' and  property_name = 'INSTANCE_NAME';

DEV  - tswmsea.dev.bcldb.com_dev_94x   
INT3 - tswmsea.int3.bcldb.com_int3_94x
INT1 - tswmsea.int1.bcldb.com_int1_94x 
INT5 - kdci5wmsea1.bcliquor.com_wms
PROD - ddcpwmsea1.bcliquor.com_wms



3. Deploy md-tools file in sequence given.


4. refresh meta-database

5. deploy Jasper reports


## The purpose of this document is to provide the deployment steps for Jasper reports on Tecsys Application server 

#### The jasper_deploy batch file finds the Tecsys deployment path and deploy jasper files to the %TECSYS_HOME%\WEB-INF\classes\jasper

a.	Checkout Jasper reports from SVN repo http://subversion.bcliquor.com/svn/WMS/Reports/trunk/jasper


b.	Open command prompt as administrator (Run as Administrator)

c. run below commands on command prompt

cd D:\TEMP\Jasper
jasper_deploy.bat



6. restart the portal




