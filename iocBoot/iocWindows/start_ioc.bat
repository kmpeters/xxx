@echo OFF

SETLOCAL

REM This should match an existing subdirectory of the IOC's bin dir
set EPICS_HOST_ARCH=windows-x64-static

REM set EPICS_CA_MAX_ARRAY_BYTES=100000000

REM Add caRepeater to the PATH
REM set PATH=%PATH%;D:/epics/base-3.14.12.5/bin/windows-x64

REM Go to the startup directory
cd %~dp0

REM dlls to the PATH
call dllPath.bat

REM start the IOC
..\..\bin\%EPICS_HOST_ARCH%\xxx st.cmd

pause

ENDLOCAL
