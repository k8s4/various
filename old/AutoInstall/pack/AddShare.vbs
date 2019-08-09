Dim WSHShell, FSO
set WSHShell = WScript.CreateObject("WScript.Shell")
set FSO = WScript.CreateObject("Scripting.FileSystemObject")

AddShare "%SystemDrive%\public"

Sub AddShare(arg_share)
    full_folder_path = WshShell.ExpandEnvironmentStrings(arg_share)
    ask_share =  WSHShell.Popup ("Создать сетевую папку " & full_folder_path & "?", 0, "AddShare", vbYesNo + vbInformation + vbDefaultButton1)
    if ask_share = vbNo Then
        WScript.Quit()
    end if
    if (fso.FolderExists(full_folder_path)) Then
        WSHShell.Popup "Папка " + full_folder_path + " уже существует.", 0, "CreateFolder", vbExclamation
    else
        FSO.CreateFolder(full_folder_path)
    end if
    WScript.Sleep(500)
    WSHShell.Run "net user Гость /passwordchg:no /active:yes /y",0
    WScript.Sleep(500)
    WSHShell.Run "net share public=" + full_folder_path + " /unlimited",0
End Sub
