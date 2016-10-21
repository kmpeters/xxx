@echo ON

SETLOCAL

REM set EPICS_HOST_ARCH=windows-x64

REM set EPICS_CA_MAX_ARRAY_BYTES=100000000

REM Add caRepeater to the PATH
REM set PATH=%PATH%;D:/epics/base-3.14.12.5/bin/windows-x64

REM dlls to the PATH
call dllPath.bat

REM start the IOC
..\..\bin\%EPICS_HOST_ARCH%\xxx st.cmd

pause

ENDLOCAL
