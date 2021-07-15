IT Support Center: 1-888-544-8444 (for email, remote access etc.)
=================================================================

DEV: https://wmsutils.dev.bcldb.com/
server: kdcpwfapp01/02 on port 8443

INT5: https://wmsutils.int5.bcldb.com/
server: kdci5wfapp01/02 and ldq9i5wfapp01/02

PROD: https://wmsutils.bcldb.com/
Server: kdcpwfapp01/02 and ldq9pwfapp01/02


WMS Util Application (Web application)
---------------------------------------
##Wildfly Console 

DEV
http://kdcdwfappctrl01:9990/console
User: BIKAHLON
Password: TVkB3kku@



##Wildfly Console - (web Service)
--------------------------------------

DEV
-------
http://kdcdwfctrl01:9990/console

User: bikahlon
Password:TVkB3kku@

INT5
-------
http://kdci5wfctrl01:9990/console
User: bikahlon
Password:Today123

Wildfly Console - HPI war
---------------------------
username: bikahlon
password: 2S*P2ghA

DEV
https://ldq9dwfextctrl01:9443/console/index.html

INT5
https://ldq9i5wfextctrl01:9443/console/index.html



Wildfly EPM - Application monitoring
--------------------------------------
https://isitup.bcldb.com:4000/login

user: bikahlon
password: 77cPd6wT


##SVN 
-----------
repo: http://subversion.bcliquor.com/svn/SOA/Services

login: bikahlon/password


##weblogic - Wholesale Price Service
-------------------------------------
DEV
-----------
url: http://services.dev.bcldb.com:25201/console/login/LoginForm.jsp
login : bikahlon/01password

INT5
-----------
http://kdci5wfctrl01:9990/console/
User: bikahlon
Password: Today123


HPI Application: 
-----------
DEV :https://productcatalogue.dev.bcldb.com/
username/password: agus.kanihatu@bcldb.com / newPass02

INT5 :https://productcatalogue.int5.bcldb.com/
username/password: agus.kanihatu@bcldb.com / newPass03


PROD: https://productcatalogue.bcldb.com
Userid: Anureet.gill@bcldb.com 
Password: Gilmore3383



##JNDI Connection
-----------------

<connection-url>jdbc:oracle:thin:@hypnos:1521:devl4</connection-url>

<connection-url>jdbc:oracle:thin:@vxena:1521:scdevl9</connection-url>


##PostgreSQL 
--------------

psql -U {username} -d {database_name} -h {host_name}

\i filename.sql

psql -U wsprice_repo -d co_db -h kdcdpgrsql02





##JBoss development enviorment
------------------------------
http://kdcdjbctrl01:9990/console/App.html
username: bikahlon
password: or@cle123

###WSDL
----------------------
production:  http://esb.bcldb.com:25011/LDB_Retail/ProductPrice?wsdl
development: http://corpws.d2.bcldb.com:8080/ProductPriceService/ProductPriceService?wsdl


Continuos Integration 
----------------------------
http://nexus.bcliquor.com/

http://jenkins.bcliquor.com/


##WMS
-----------------

DEV wms controller
https://tswmsea.dev.bcldb.com/TecsysCP2/

user/pass: tecsys/devtcp


INT3 wms controller
https://tswmsea.int3.bcldb.com/TecsysCP2/

user/pass: tecsys/tecsys


wms dev
https://tswmsea.dev.bcldb.com/dev_94x/

wms sandbox
https://tswmsea.sbox.bcldb.com/sbx_94x/



Tecsys-Iguana-int3
----------------------

http://tswmsig.int3.bcldb.com:6543/dashboard.html
username: admin/admin



Tecsys-Iguana-Prodcution
----------------------

http://tswmsig.bcldb.com:6543/dashboard.html
username: admin/adminwms

data file : \\ddcpwmsig1\ddc\
logs: \\ddcpwmsig1\logs


iStore
--------------------------------------

eBiz: Enviorments 

http://kdcpwiki02.bcliquor.com/wiki/EBS12_Environments

To log into istore (TST3):

url : http://kdctebs62.bcliquor.com:8000/OA_HTML/ibeCZzdMinisites.jsp

Username:
127F6FD2CD544159B06FB73BA2EC950D_000001
Password: 123oracle


log file: 

Kdctebs62 oacore log file location
/opt/u01/EBIZI6/fs1/FMW_Home/user_projects/domains/EBS_domain_EBIZI6/servers/oacore_server2/logs

iStore INT3
--------------
https://webstore.int3.bcldb.com/OA_HTML/ibeCZzpHome.jsp
UserID: inttest005
PW: oracle01



iStore DEV3
--------------
https://webstore.dev3.bcldb.com/OA_HTML/ibeCZzpHome.jsp
UserID: udevelopment4
PW: Wha2 will work?

sku>352005



iStore database DEV3
--------------
username: apps
password: bucket1  
HOST=kebs12test
PORT=1521



MSM
--------------------------------------

https://support.bcldb.com/MSM/RFP/Forms/Request.aspx?id=345837

username: bikahlon
password: Canada2020




Tecsys SSO
--------------------------------------
Development Instance
https://tswmsea.dev.bcldb.com/dev_94x/

username: mshklove_dev
password: Password01



Jasper Reports
-------------------------------------
sqlcmd -i 00_batch_run.sql -S tswmsdb.int3.bcldb.com -d int3_94x_w -U wmsservice -P !on4ldbwms



wms INT3
username system 
password int3sit


Jira
----------
bikram.kahlon@bcldb.com
password India2020

Read-Only


Tecsys Patch location 
x:\temporary\andywong\tecsys\wms\patch\


Jasper Properties Debug (Enable value 1; disable value 0)
--------------------------
jasper.output.format=1
debug.key.MetaPrintReportCommand=1


LDB Item service 
-----------------------
- database - Postgresql
#DEV
username: ldbitem_app/ldbitem_dev

#INT5
host:kdcipgrsql01
db: co_db_i5
Id: bikahlon
Password: Today123

Wholesale Price 
---------------------
- database - Postgresql
#INT5
host: ldq9i5pgrsql01
db: co_db
Id/password:Bikahlon/Today123
schema wsprice_app



