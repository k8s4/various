Dim WSHShell, UserInstScript
set WSHShell = WScript.CreateObject("WScript.Shell")
UserInstScript = "AutoScript"

ask_al =  WSHShell.Popup ("Отчистка реестра...", 0, "Del AutoLogon", vbYesNo + vbInformation + vbDefaultButton1)
if ask_al = vbNo Then
    WScript.Quit()
end if
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon", "0"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUserName", "Администратор"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AltDefaultUserName", "Администратор"
WSHShell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword"
WSHShell.Run "net localgroup Администраторы "+UserInstScript+" /delete /y",0
WScript.Sleep(500)
WSHShell.Run "net user "+UserInstScript+" /delete /y",0
WScript.Sleep(500)
WSHShell.RegDelete "HKLM\SOFTWARE\AutoRoScript"
WSHShell.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript"
