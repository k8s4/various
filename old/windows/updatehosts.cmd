rem Repo https://github.com/StevenBlack/hosts
rem file for autoupdate hosts
@echo off
set pypath="c:\Python3"
set schpath="C:\Windows\System32"
set workpath="c:\hosts"
set dst="c:\windows\system32\drivers\etc\hosts"

%schpath%\schtasks.exe /query /TN "SPECIAL\UPDATEHOSTS" >NUL 2>&1
if %errorlevel% NEQ 0 %schpath%\schtasks.exe /create /SC WEEKLY /RL HIGHEST /TN "SPECIAL\UPDATEHOSTS" /TR "%0" /ST 21:00

cd %workpath%
%pypath%\python.exe %workpath%\makeHosts.py 
xcopy /Y %workpath%\hosts %dst%
exit 0
