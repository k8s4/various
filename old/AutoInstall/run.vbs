Dim WSHShell, FSO, UserInstScript, TargetPathPack, Free_Space, ask_install, Reg_Run
Set WSHShell = WScript.CreateObject("WScript.Shell")
Set FSO = WScript.CreateObject("Scripting.FileSystemObject")
UserInstScript = "AutoScript"


TargetPathPack = WshShell.ExpandEnvironmentStrings("%temp%\TempROScript")
WSHShell.RegWrite "HKLM\SOFTWARE\AutoRoScript", TargetPathPack

Reg_Run = WSHShell.RegRead("HKLM\SOFTWARE\AutoRoScript")
ask_install =  WSHShell.Popup ("Начать установку программ?", 0, "AddLink", vbYesNo + vbInformation + vbDefaultButton2)
if ask_install = vbNo Then
    WScript.Quit()
end if
Free_Space = FormatNumber(fso.GetDrive("C").FreeSpace/1048576, 1)
If Free_Space < 1024 Then
    WSHShell.Popup("На диске C:\, требуется 1024Мб!. Свободно " & Free_Space & "Мб!")
    WScript.Quit()
End If
FSO.CreateFolder TargetPathPack
FSO.CopyFolder ".\pack", TargetPathPack
WSHShell.Run "net user "+UserInstScript+" 312452314321 /add /passwordchg:no /y",0
WScript.Sleep(500)
WSHShell.Run "net localgroup Администраторы "+UserInstScript+" /add",0
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon", "1"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUserName", UserInstScript
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AltDefaultUserName", UserInstScript
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword", "312452314321"
WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript", Reg_Run & "\main.vbs -sp4"
WScript.Sleep(2000)
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate,(Shutdown)}!\\.\root\cimv2")
Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
For Each objOperatingSystem in colOperatingSystems
    ObjOperatingSystem.Reboot()
Next
