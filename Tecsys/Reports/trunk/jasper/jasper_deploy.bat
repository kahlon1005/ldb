@setlocal enableextensions enabledelayedexpansion
@echo off
echo Jasper reports deployment script
cd D:\wildfly-8.2.1.Final-jdk-1.8.0\
FOR /F %%I IN ('dir TecsysWeb.war /s/b') DO call :copyJasperFiles "%%I"
goto :eof


:copyJasperFiles
set TECSYS_HOME=%~dpnx1
if not x%TECSYS_HOME:deployment=%==x%TECSYS_HOME% (
  cd d:\TEMP\Jasper
  xCopy /S *.j* %TECSYS_HOME%\WEB-INF\classes\jasper  
  xCopy /S *.gif %TECSYS_HOME%\WEB-INF\classes\jasper  
  echo Jasper reports copied and logo to %TECSYS_HOME%\WEB-INF\classes\jasper  
)
goto :eof



