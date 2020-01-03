
On Error Resume Next
Dim PauseTime, Start, Finish, TotalTime

'PauseTime = 60  ' Set duration.
Start = Timer   ' Set start time.
Do While Timer < Start + PauseTime
DoEvents   ' Yield to other processes.
Loop
Finish = Timer   ' Set end time.
TotalTime = Finish - Start   ' Calculate total time.

Dim AccountObj,PassAge,strUserid,wsShell,strText

Set WshShell = CreateObject("Wscript.Shell")

Dim oShell



Set WshNetwork = WScript.CreateObject("WScript.Network")

strUserid = WshNetwork.UserName

Set AccountObj = GetObject("WinNT://EURO")

    Set UserObj = GetObject("WinNT://EURO/"& strUserid)
    PassAge = UserObj.Get("PasswordAge")
    PassAge = Round(((PassAge / 3600) / 24),0)
    PassAge = 90 - PassAge

If PassAge < 99 then
'Creating IE object
          Set IE = CreateObject("InternetExplorer.Application")
          ie.width=450
          ie.height=500
          ie.top=0
          ie.left=0
          ie.menubar=0
          ie.statusbar=0
          ie.resizable=0
          ie.toolbar=0
          ie.navigate ("About:blank")
          ie.document.title="Password expiry check"
	  strText=StrText & "<BR><BR><Font Size=+0><I>Âàø ïàðîëü èñòåêàåò ÷åðåç   " & PassAge & " äíåé</I></font></P>"
	  strText=StrText & "<BR><BR><Font Size=+0><I>Ïîëüçîâàòåëü:  " & strUserid & " </I></font></P>"
 	  strtext=strtext & "<BR><BR><Font Size=+0><I>×òîáû ïîìåíÿòü ïàðîëü, íàæìèòå Ctrl+Alt+Delete and êëèêíèòå Ñìåíà ïàðîëÿ</I></font></P>"
	  strtext=strtext & "<BR><BR><Font Size=+2><I>***×òîáû çàêðûòü ýòî îêíî ïîæàëóéñòà íàæìèòå íà X â âåðõíåì ïðàâîì óãëó***</I></font></P>"	
ie.document.body.innerHTML=strtext
	  ie.visible=1
	  set IE=Nothing

Set oShell = WScript.CreateObject ("WSCript.shell")
oShell.run "cmd /C  cd c:\Program Files\Network Associates\Common Framework & cmdagent.exe /P /E /C"
Set oShell = Nothing

End If    

If Err <> 0 then
   Wscript.Quit
End If
