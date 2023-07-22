@echo off
setlocal

:PROMPT
SET /P AREYOUSURE=You are about to prep this system for imaging with a BIOS boot. Are you sure (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

netsh advfirewall firewall add rule name="Fog Client" dir=in action=allow program="%ProgramFiles(x86)%\FOG\FOGService.exe"
netsh advfirewall firewall add rule name="Fog Service" dir=in action=allow program="%ProgramFiles(x86)%\FOG\FOGServiceConfig.exe"
netsh advfirewall firewall add rule name="Fog Tray" dir=in action=allow program="%ProgramFiles(x86)%\FOG\FOGTray.exe"

sc config "FOGService" start= disabled
mkdir C:\Windows\Setup\scripts

(echo "wmic useraccount WHERE "Name=w9admin" SET PasswordExpires=FALSE" & echo "wmic useraccount WHERE 'Name=w9guest' SET PasswordExpires=FALSE" & echo "sc config FOGService start= delayed-auto" & echo "shutdown -t 0 -r") > C:\Windows\Setup\scripts\SetupComplete.cmd
(echo "echo Y | del %appdata%\microsoft\windows\recent\automaticdestinations\*" & echo "del %0") > "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\runonce.bat"

rmdir C:\customize /s /q

C:\Windows\System32\Sysprep\sysprep.exe /generalize /shutdown /oobe /unattend:%~dp0unattendBIOS.xml

:END
endlocal
