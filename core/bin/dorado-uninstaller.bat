@echo off

if "%OS%"=="Windows_NT" goto nt

echo This is not NT, so please edit this script and set _APP_HOME manually
set _APP_HOME=..
goto set_java_home

:nt
rem %~dp0 is name of current script under NT
set _APP_HOME=%~dp0
set _APP_HOME=%_APP_HOME:\bin\=%

:set_java_home
if "%1"=="" goto uninstall
set JAVA_HOME=%1

:uninstall
"%_APP_HOME%\ant\bin\ant.bat" -f "%_APP_HOME%\conf\dorado-install.xml" uninstall
goto exit

:exit
PAUSE