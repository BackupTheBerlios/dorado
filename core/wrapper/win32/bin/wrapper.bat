@echo off
rem
rem Find the application home.
rem

if "%OS%"=="Windows_NT" goto nt

echo This is not NT, so please edit this script and set _APP_HOME manually
set _APP_HOME=..

goto conf

:nt
rem %~dp0 is name of current script under NT
set _APP_HOME=%~dp0
rem : operator works similar to make : operator
set _APP_HOME=%_APP_HOME:\bin\=%


rem
rem Find the wrapper.conf
rem
:conf
set _WRAPPER_CONF="%_APP_HOME%\conf\wrapper.conf"

rem
rem What must i do?
rem
if "%1" == "start" goto start
if "%1" == "stop" goto stop
if "%1" == "restart" goto restart
if "%1" == "console" goto console
if "%1" == "install" goto install
if "%1" == "uninstall" goto uninstall

:help
echo Usage: $0 [start | stop | restart | console | install | remove]
goto end

REM
REM Starts the Tomcat-Service
REM
:start
if not exist "%_APP_HOME%\bin\service" goto installAndStart
"%_APP_HOME%\bin\wrapper.exe" -t %_WRAPPER_CONF%
if not errorlevel 1 goto end
pause
goto end

REM
REM Stops the Tomcat-Service
REM
:stop
"%_APP_HOME%\bin\wrapper.exe" -p %_WRAPPER_CONF%
if not errorlevel 1 goto end
pause
goto end

REM
REM Restarts the Tomcat-Service
REM
:restart
"%_APP_HOME%\bin\wrapper.exe" -p %_WRAPPER_CONF%
"%_APP_HOME%\bin\wrapper.exe" -t %_WRAPPER_CONF%
if not errorlevel 1 goto end
pause
goto end

REM
REM Starts the Tomcat as Console Application
REM
:console
"%_APP_HOME%\bin\wrapper.exe" -c %_WRAPPER_CONF%
if not errorlevel 1 goto end
pause
goto end

REM
REM Installs the Tomcat-Service
REM
:install
"%_APP_HOME%\bin\wrapper.exe" -i %_WRAPPER_CONF%
echo Do not delete this file manually. > "%_APP_HOME%/bin/service"
if not errorlevel 1 goto end
pause
goto end

REM
REM Installs and starts the Tomcat-Service
REM
:installAndStart
"%_APP_HOME%\bin\wrapper.exe" -i %_WRAPPER_CONF%
echo Do not delete this file manually. > "%_APP_HOME%/bin/service"
"%_APP_HOME%\bin\wrapper.exe" -t %_WRAPPER_CONF%
if not errorlevel 1 goto end
pause
goto end

REM
REM Removes the Tomcat-Service
REM
:uninstall
"%_APP_HOME%\bin\wrapper.exe" -r %_WRAPPER_CONF%
del "%_APP_HOME%\bin\service"
if not errorlevel 1 goto end
pause
goto end



:end
set _APP_HOME=
set _WRAPPER_CONF=

