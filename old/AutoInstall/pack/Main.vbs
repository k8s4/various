Dim WSHShell, FSO, Args
Set WSHShell = WScript.CreateObject("WScript.Shell")
Set FSO = WScript.CreateObject("Scripting.FileSystemObject")
Set Args = WScript.Arguments
Reg_Run = WSHShell.RegRead("HKLM\SOFTWARE\AutoRoScript")
WScript.Sleep(10000)
On Error Resume Next
ArgumetSet = Args(0)
If err then
    WScript.Quit()
End If
On Error Goto 0
If (ArgumetSet = "-sp4") Then
    InstallSP4()
ElseIf (ArgumetSet = "-ie6") Then
    InstallIE6()
ElseIf (ArgumetSet = "-ie6sp1") Then
    InstallIE6SP1()
ElseIf (ArgumetSet = "-pathu") Then
    WSHShell.Run Reg_Run&"\CreateList.vbs -typeq",0
    WSHShell.Run Reg_Run&"\starttypeu.cmd",0
    WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript", Reg_Run & "\main.vbs -pathq"
    WScript.Sleep(500)
ElseIf (ArgumetSet = "-pathq") Then
    WSHShell.Run Reg_Run&"\CreateList.vbs -prog",0
    WSHShell.Run Reg_Run&"\starttypeq.cmd",0
    WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript", Reg_Run & "\main.vbs -progs"
    WScript.Sleep(500)
ElseIf (ArgumetSet = "-progs") Then
    WSHShell.Run Reg_Run&"\InstProg.cmd",0
    WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript", Reg_Run & "\main.vbs -office"
ElseIf (ArgumetSet = "-office") Then
    WSHShell.Run Reg_Run&"\OfficeInst.vbs"
    WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript", Reg_Run & "\main.vbs -fix"
ElseIf (ArgumetSet = "-fix") Then
    WSHShell.Run Reg_Run&"\AddRegKey.vbs"
    WScript.Sleep(1000)
    WSHShell.Run Reg_Run&"\AddLink.vbs"
    WScript.Sleep(1000)
'    WSHShell.Run Reg_Run&"\AddShare.vbs"
'    WScript.Sleep(1000)
'    WSHShell.Run Reg_Run&"\AddSysFile.vbs"
'    WScript.Sleep(1000)
    WSHShell.Run Reg_Run&"\DelAutoROScript.vbs"
End If

Sub InstallSP4()
    On Error Resume Next
    reg_check = WSHShell.RegRead("HKLM\SOFTWARE\Microsoft\Updates\Windows 2000\SP4\Q327194\Description")
    If err then
        WSHShell.Run Reg_Run&"\update\w2ksp4ru.exe -u",0
        WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript", Reg_Run & "\main.vbs -ie6"
        Exit Sub
    End If
    On Error Goto 0
    If (reg_check = "Windows 2000 Service Pack 4") Then
        WSHShell.Popup reg_check + " уже установлен.", 0, "SP4", vbOKOnly + vbExclamation
    Else
        WSHShell.Popup reg_check + " уже установлен. Ошибка версии.", 0, "SP4", vbOKOnly + vbExclamation
    End If
End Sub

Sub InstallIE6()
    On Error Resume Next
    reg_check = WSHShell.RegRead("HKLM\SOFTWARE\Microsoft\Internet Explorer\Version")
    If err then
        WSHShell.Popup "Ошибка: Ключ версии IE не существует.", 0, "Reg Key NotFound", vbOKOnly + vbExclamation
        Exit Sub
    End If
    On Error Goto 0
    If (reg_check = "6.0.2600.0000") OR (reg_check = "6.0.2800.1106") Then
        WSHShell.Popup "Internet Explorer "+reg_check+" уже установлен.", 0, "IE6", vbOKOnly + vbExclamation
    ElseIf (reg_check = "5.00.2920.0000") OR (reg_check = "5.00.3315.1000") OR (reg_check = "5.00.3700.1000") Then
        WSHShell.Run Reg_Run&"\IE\IE6\ie6setup.exe /Q",5
        WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript", Reg_Run & "\main.vbs -ie6sp1"
    End If
End Sub

Sub InstallIE6SP1()
    On Error Resume Next
    reg_check = WSHShell.RegRead("HKLM\SOFTWARE\Microsoft\Internet Explorer\Version")
    If err then
        WSHShell.Popup "Ошибка: Ключ версии IE не существует.", 0, "Reg Key NotFound", vbOKOnly + vbExclamation
        Exit Sub
    End If

    On Error Goto 0
    If (reg_check = "6.0.2800.1106") Then
        WSHShell.Popup "Internet Explorer "+reg_check+" уже установлен.", 0, "IE6", vbOKOnly + vbExclamation
    ElseIf (reg_check = "6.0.2600.0000") Then
        WSHShell.Run Reg_Run&"\CreateList.vbs -typeu",0
        WSHShell.Run Reg_Run&"\IE\IE6SP1\ie6setup.exe /Q",5
        WSHShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutoRoScript", Reg_Run & "\main.vbs -pathu"
    End If
End Sub

