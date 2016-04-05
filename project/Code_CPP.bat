@echo OFF

setlocal ENABLEEXTENSIONS
set projectcfg=%~dp0..\..\..\project.cfg
set vssln=Plugin SDK.sln
set cerootvar=CRYENGINEROOT
set regkeyname=HKEY_CURRENT_USER\Software\Crytek\CryEngine

:: OMGGOMB: CEV 
:: Disabled exits on error since if engine_root is not found the 
:: Plugin_SDK still has the old directory structure configured (for SDKs pre CEV)
:: ~OMMGGOMB

if not exist "%projectcfg%" (
    1>&2 echo "Error: %projectcfg% not found!"
	::pause
    ::exit /b 1
)

for /F "tokens=*" %%I in (%projectcfg%) do set %%I

if not defined engine_version (
	1>&2 echo "Error: no engine_version entry found in %projectcfg%!"
	::pause
    ::exit /b 1
)

for /F "usebackq tokens=2,* skip=2" %%L in (
	`reg query "%regkeyname%" /v %engine_version%`
) do set "engine_root=%%M"

if defined engine_root (
	if not exist "%engine_root%" (
		1>&2 echo "Error: %engine_root% not found!"
		::pause
		::exit /b 1
	)
	setx %cerootvar% "%engine_root%"
	start "" "%vssln%"
	exit
) else (
    1>&2 echo "Error: Engine version %engine_version% not found!"
	::pause
    ::exit /b 1
)