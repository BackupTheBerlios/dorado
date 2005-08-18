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

REM This Shell Script connects Tomcat 5.5 with the Apache2 Webserver.
 
if "%OS%"=="Windows_NT" @setlocal
if "%OS%"=="WINNT" @setlocal

set TOMCAT_BASE=dorado.tomcat.base
set TOMCAT_HOME=dorado.tomcat.home
set DORADO_INSTALLER_DIR=dorado.installer.dir
set JAVA_HOME=java.home

set APACHE_HOME=%PROGRAMFILES%\Apache Group\Apache2
if exist "%APACHE_HOME%" goto install
goto APACHE_HOME_not_found

:APACHE_HOME_not_found
set /p AH=Bitte geben Sie den Installationsort des Apache2-Webservers ein [%PROGRAMFILES%\Apache Group\Apache2]:
if "%AH%" == "" goto APACHE_HOME_default
set APACHE_HOME=%AH%
goto check_install

:APACHE_HOME_not_found_and exit
echo "No Apache2 Webserver Installation found. Exit now."
goto end

:APACHE_HOME_default
set APACHE_HOME=%PROGRAMFILES%\Apache Group\Apache2

:check_install
if exist "%APACHE_HOME%" goto install
goto APACHE_HOME_not_found_and exit

:install
echo "Installing now"
call "%APACHE_HOME%\bin\Apache.exe" -k stop
call %DORADO_INSTALLER_DIR%/ant/bin/ant.bat -Ddorado.apache.home="%APACHE_HOME%" -f %DORADO_INSTALLER_DIR%/conf/dorado-install.xml install-jk-apache2-win32


:restart
echo "Restarting the Tomcat Server"
call %TOMCAT_BASE%\bin\restart.bat

echo "Restarting the Apache Webserver"
call "%APACHE_HOME%\bin\Apache.exe" -k start

:end
if "%OS%"=="Windows_NT" @endlocal
if "%OS%"=="WINNT" @endlocal