## The purpose of this document is to provide the deployment steps Jasper reports databse objects

1.	Checkout Jasper reports database scripts from SVN repo http://subversion.bcliquor.com/svn/WMS/Reports/Jasper/database to D:\TEMP\Jasper\database
2.	Open command prompt as administrator (Run as Administrator)

3.      use the window command below to execute sql scripts
		cd D:\TEMP\Jasper\database
        sqlcmd -E -i 00_batch_run.sql -S <domain_name> -d <database>

replace <domain_name> and <database> as shown in example below for dev
##example (dev): sqlcmd -E -i 00_batch_run.sql -S tswmsdb.dev.bcldb.com -d dev_94x_w

sqlcmd -S tswmsdb.dev.bcldb.com -d dev_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql
sqlcmd -S tswmsdb.int3.bcldb.com -d int3_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql
sqlcmd -S tswmsdb.int1.bcldb.com -d int1_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql
sqlcmd -S tswmsdb.int5.bcldb.com -d int5_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql
sqlcmd -S tswmsdb.int4.bcldb.com -d int4_94x_w  -U tecsys -P tecsys -i 00_batch_run.sql