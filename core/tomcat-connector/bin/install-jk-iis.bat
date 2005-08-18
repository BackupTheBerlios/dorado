@echo off

REM
REM Copyright (c) 2005, dorado.planetes.de
REM All rights reserved.
REM
REM Redistribution and use in source and binary forms, with
REM or without modification, are permitted provided that the
REM following conditions are met:
REM
REM    *  Redistributions of source code must retain the a
REM        bove copyright notice, this list of conditions and the
REM        following disclaimer.
REM    *  Redistributions in binary form must reproduce the
REM        above copyright notice, this list of conditions and
REM        the following disclaimer in the documentation and/
REM        or other materials provided with the distribution.
REM    *  Neither the name of the planetes.de, centaurus nor the
REM        names of its contributors may be used to endorse
REM        or promote products derived from this software
REM        without specific prior written permission.
REM
REM THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT
REM HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
REM EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
REM BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
REM MERCHANTABILITY AND FITNESS FOR A PARTICULAR P
REM URPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REM COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
REM ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
REM EXEMPLARY, OR CONSEQUENTIAL DAMAGES
REM (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
REM SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
REM OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
REM CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
REM IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
REM NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
REM OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
REM THE POSSIBILITY OF SUCH DAMAGE.
REM

REM This Shell Script connects Tomcat 5.5 with the IIS Webserver.
 
if "%OS%"=="Windows_NT" @setlocal
if "%OS%"=="WINNT" @setlocal

set TOMCAT_BASE=dorado.tomcat.base
set TOMCAT_HOME=dorado.tomcat.home
set DORADO_INSTALLER_DIR=dorado.installer.dir
set JAVA_HOME=java.home

set server=%1

if "%1" == "" goto noServer
goto exec

:noServer
set server=1

:exec
echo "Starting the configurator..."
rem cd %DORADO_INSTALLER_DIR%
rem set ANT_HOME=%DORADO_INSTALLER_DIR%/ant
call %DORADO_INSTALLER_DIR%/ant/bin/ant.bat -f %DORADO_INSTALLER_DIR%/conf/dorado-install.xml install-jk-iis

md %TOMCAT_HOME%\tomcat-connector
md %TOMCAT_HOME%\tomcat-connector\lib
md %TOMCAT_HOME%\tomcat-connector\logs
xcopy /Y %DORADO_INSTALLER_DIR%\tmp\tomcat-connector\*.* %TOMCAT_HOME%\tomcat-connector
xcopy /Y %DORADO_INSTALLER_DIR%\tmp\tomcat-connector\lib\*.* %TOMCAT_HOME%\tomcat-connector\lib

rd /S /Q %DORADO_INSTALLER_DIR%\tmp\tomcat-connector

echo "Installing the ISAPI_REDIRECT.dll into the vhost(s)"
%SystemRoot%\system32\cscript.exe "%DORADO_INSTALLER_DIR%\tomcat-connector\bin\_internal_isapi_install.vbs" %server%

echo "Restarting the Tomcat Server"
call %TOMCAT_BASE%\bin\restart.bat

echo "Restarting the IIS"
call iisreset


if "%OS%"=="Windows_NT" @endlocal
if "%OS%"=="WINNT" @endlocal
