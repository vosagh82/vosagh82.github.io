@echo off

SET VERSION-GLPI="2.5.1"
SET REG-GLPI="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FusionInventory-Agent"
SET PATHGLPI="\\10.88.20.110\share\install\glpi"

reg query %REG-GLPI% /v  DisplayVersion | findstr.exe %VERSION-GLPI% > nul
IF %errorlevel%==0 goto END
reg query %REG-GLPI% > nul
IF %errorlevel%==0 goto UNISTALL
goto INSTALL

:INSTALL
echo "Intstall"

start /wait %PATHGLPI%\fusioninventory-agent_windows-x64_%VERSION-GLPI%.exe /S /acceptlicense /execmode=Service
regedit /s %PATHGLPI%\glpi.reg
net start FusionInventory-Agent

goto END

:UNISTALL
echo "Unistall"
"%PROGRAMFILES%\FusionInventory-Agent\Uninstall.exe" /S
goto END

:END
echo "Finish"
