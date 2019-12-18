@echo off

SET VERSION-GLPI="2.5.1"
SET REG-GLPI="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FusionInventory-Agent"

reg query %REG-GLPI% /v  DisplayVersion | findstr.exe %VERSION-GLPI% > nul
IF %errorlevel%==0 goto END
reg query %REG-GLPI% > nul
IF %errorlevel%==0 goto UNISTALL
goto INSTALL

:INSTALL
echo "Intstall"
goto END

:UNISTALL
echo "Unistall"
goto END

:END
echo "Finish"
