Dim WSHShell, FSO, Args
Set WSHShell = WScript.CreateObject("WScript.Shell")
Set FSO = WScript.CreateObject("Scripting.FileSystemObject")
Set Args = WScript.Arguments
Reg_Run = WSHShell.RegRead("HKLM\SOFTWARE\AutoRoScript")

On Error Resume Next
ArgumetSet = Args(0)
If err then
    WScript.Quit()
End If
On Error Goto 0
If (ArgumetSet = "-typeu") Then
    CreateList "starttypeu", Reg_Run & "\Update\typeu\", "-u -z -o", " "
ElseIf (ArgumetSet = "-typeq") Then
    CreateList "starttypeq", Reg_Run & "\Update\typeq\", "-q", " "
ElseIf (ArgumetSet = "-prog") Then
    CreateList "InstProg", Reg_Run&"\", " ", "auto*"
End If

Sub CreateList(name_file, PathList, options_path, FindDir)
    Call WSHShell.Run ("cmd /c dir "&PathList&FindDir&" /b >"&Reg_Run&"\"&name_file&".tmp",0)
    WScript.Sleep(500)

    Set file_start = fso.OpenTextFile(Reg_Run&"\"&name_file&".cmd", 8, true)




        If Err Then
            file_start.WriteLine(Reg_Run&"\restart.vbs")
            WScript.Sleep(500)
            WScript.Quit()
        End If
        On Error Goto 0
        file_start.WriteLine(PathList&tmp_line_file&" "&options_path)
    Loop
End Sub
