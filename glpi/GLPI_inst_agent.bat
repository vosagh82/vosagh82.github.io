@echo off
sc query FusionInventory-Agent | find "1060" > nul
IF %errorlevel%==0 goto 1
sc query FusionInventory-Agent | find "STOPPED" > nul
if %errorlevel%==0 (
			goto 1) ELSE (
			goto end)
:1
IF "%PROCESSOR_ARCHITECTURE%"=="x86" (
		start /wait \\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\fa32.exe /S /acceptlicense /execmode=Service ) ELSE (
		start /wait \\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\fa64.exe /S /acceptlicense /execmode=Service )

:end
systeminfo | find /i "ptltd  - 50000" > nul && ren "C:\Program Files\FusionInventory-Agent\perl\bin\dmidecode.exe" _dmidecode.exe
xcopy \\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\screen.pm "%programfiles%\FusionInventory-Agent\perl\agent\FusionInventory\Agent\Task\Inventory\Generic" /y
xcopy \\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\HyperV2.pm "%programfiles%\FusionInventory-Agent\perl\agent\FusionInventory\Agent\Task\Inventory\Virtualization" /y
xcopy "\\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\Deploy\*" "%programfiles%\FusionInventory-Agent\perl\agent\FusionInventory\Agent\Task\Deploy" /I /S /E /y
xcopy "\\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\WMI\*" "%programfiles%\FusionInventory-Agent\perl\agent\FusionInventory\Agent\Task\WMI" /I /S /E /y
xcopy \\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\Deploy.pm "%programfiles%\FusionInventory-Agent\perl\agent\FusionInventory\Agent\Task\" /y
xcopy \\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\WMI.pm "%programfiles%\FusionInventory-Agent\perl\agent\FusionInventory\Agent\Task\" /y
xcopy "\\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\certs\*" "%programfiles%\FusionInventory-Agent\certs\" /I /S /E /y
regedit /s \\corp.isddesign.com\SYSVOL\corp.isddesign.com\scripts\GLPI\glpintz.reg
net stop FusionInventory-Agent
net start FusionInventory-Agent
"%programfiles%\FusionInventory-Agent\fusioninventory-agent.bat" -f