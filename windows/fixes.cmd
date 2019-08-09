@echo off
rem Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

echo TurnOFF System Hibernation
powercfg /H off

echo TurnOFF SMBv1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 –Force

echo TurnOFF IPv6
netsh interface teredo set state disabled
netsh interface ipv6 6to4 set state state=disabled undoonstop=disabled
netsh interface ipv6 isatap set state state=disabled

echo TurnOFF SSDP and DNSCache
sc config "SSDPSRV" start= "disabled"
sc config "Dnscache" start= "disabled"

rem Install dot.net 3.5 and old 2.0
rem DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:d:\sources\sxs
rem Install-WindowsFeature Net-Framework-Core -source \\network\share\sxs

rem Fix problem with connect to RDP
rem  REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters /v AllowEncryptionOracle /t REG_DWORD /d 2