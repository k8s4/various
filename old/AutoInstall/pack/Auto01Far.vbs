Dim WSHShell
Set WSHShell = WScript.CreateObject("WScript.Shell")
Reg_Run = WSHShell.RegRead("HKLM\SOFTWARE\AutoRoScript")
WSHShell.Run Reg_Run&"\Far\far1705.exe"
WScript.Sleep(5000)
WSHShell.AppActivate("The Far")
WScript.Sleep(500)
WshShell.SendKeys("{TAB}")
WScript.Sleep(1000)
WshShell.SendKeys("{ENTER}")
WScript.Sleep(1000)
WshShell.SendKeys("{ENTER}")
WScript.Sleep(20000)
WshShell.SendKeys("{ENTER}")
WScript.Sleep(1000)
WSHShell.AppActivate("Far manager")
WScript.Sleep(500)
WshShell.SendKeys("%{F4}")
WSHShell.Run "regedit /s "&Reg_Run&"\Far\FARSAVE1.REG"
WScript.Sleep(500)
WSHShell.Run "regedit /s "&Reg_Run&"\Far\FARSAVE2.REG"
