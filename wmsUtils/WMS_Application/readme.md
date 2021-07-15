#update all project version
`mvn versions:set -DnewVersion=2.50.1-SNAPSHOT -DprocessAllModules -DgenerateBackupPoms=false`

##replace json module in wildfly 8 with wildfly 12

`<WILDFLY_HOME>\modules\system\layers\base\com\fasterxml`

# Application.properties setup

`added VM argument -Dspring.config.location=C:\application.properties `




