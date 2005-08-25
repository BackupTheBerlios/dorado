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

if "%OS%"=="Windows_NT" goto nt
set _EXEC=ant.bat
goto exec

:nt
setlocal
set _BASEDIR=%~dp0
set _EXEC=%_BASEDIR%\ant.bat
goto exec

:exec
"%_EXEC%" -f "%_BASEDIR%\..\conf\launch\launch.xml" stop

:exit