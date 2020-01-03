' ******************************************************************************************
' * VBScript Version     1.0 		P.Nideröst		8.3.06			   *
' ****************************************************************************************** 
' * Variable Definitions

'This portion of the script sets up and defines variables and objects hat are used to perform drive mappings

	Dim strComputerName
	Dim WshLogonServer
	Dim strUserName
	Dim strDomainName
	Dim fso,f2
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set f2 = fso.GetFile("\\mossrv02\common$\ITdept\saplogon.ini")

	Set wshNetwork = WScript.CreateObject( "WScript.Network" )	
	Set WshShell = WScript.CreateObject( "WScript.Shell" )
	set wshenv = wshshell.environment( "process" )
	strComputerName = wshNetwork.computerName
	strUserName = wshNetwork.userName
	strDomainName = wshNetwork.userDomain
	WshLogonServer = WshShell.ExpandEnvironmentStrings("%LOGONSERVER%")
	adspath = "WinNT://" & strDomainName & "/" & strUserName
	set adsobj = getobject( adspath )


' *** Main Programm ************************************************************************
call main()
WScript.Quit 'Exit

' ******************************************************************************************

Sub Main()
' Main execution code
On Error Resume Next
' ******************************************************************************************
'DISPLAY MESSAGE
	grpscript = "RU Login"

	if isempty(msgtitle) then msgtitle = "NETWORK LOGON" end if
		wshshell.popup "Running Login script  " & grpscript &_
		  "  for User: " & strUserName , 2, msgtitle, 64
	
	
	Set fso2 = CreateObject("Scripting.FileSystemObject")

	if (fso2.FileExists(WshLogonServer & "\NETLOGON\RU\MOS\message.txt")) then
	   set file2 = fso2.opentextfile(WshLogonServer & "\NETLOGON\RU\MOS\message.txt")
	   CM1 = file2.readall
	   wshshell.popup CM1, 45, "Current Informations from IT-Department Russia", 16
	end If

' ******************************************************************************************
	call subSharedDriveSetup
' ******************************************************************************************
'	WshShell.Run (WshLogonServer & "\NETLOGON\ch\luc\bginfo.exe /i" & WshLogonServer & "\NETLOGON\RU\MOS\SysInfo_Default.bgi /timer:0"), 1,true
' ******************************************************************************************
'	WshShell.run (WshLogonServer & "\NETLOGON\ch\luc\SMS_CH0.vbs"), 1,true
'	WshShell.Run "\\mossrv02\uninstap\radiaclient\MSIEXECINST.cmd"

' ******************************************************************************************

End Sub


'This portion runs the subroutine that performs the drive mappings
' ******************************************************************************************
Sub subSharedDriveSetup()
	'** Setup Shared Drives based upon Groups Memberships **
	'Allows script execution to resume if a script error occurs
	On Error Resume Next
		'Performs a query of user account properties for group memberships and converts lowercase letters in the group membership name to uppercase
		for each prop in adsobj.groups
    			select case UCASE(prop.name)


				case "INTL_RU_USERS"
					HPATH = "\\mossrv02\Userpool"
					wshNetwork.RemoveNetworkDrive "K:", true, true
					wshNetwork.MapNetworkDrive "K:", HPATH

'				
					HPATH = "\\mossrv02\Common$"
					wshNetwork.RemoveNetworkDrive "O:", true, true
					wshNetwork.MapNetworkDrive "O:", HPATH
'Adding SAP INI file
					Set fso = CreateObject("Scripting.FileSystemObject")
					Set f2 = fso.GetFile("\\mossrv02\common$\ITdept\saplogon.ini")
					f2.Copy ("c:\WINDOWS\saplogon.ini")


				
				case "INTL_RU_CUST_SERV"
					HPATH = "\\mossrv02\Custom$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH

				case "INTL_RU_HR"
					HPATH = "\\mossrv02\HR$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH
					
					HPATH = "\\mossrv02\account$"
					wshNetwork.RemoveNetworkDrive "F:", true, true
					wshNetwork.MapNetworkDrive "F:", HPATH

				case "INTL_RU_MEDIC"
					HPATH = "\\mossrv02\MedDir$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH

				case "INTL_RU_MKTG"
					HPATH = "\\mossrv02\MKTG$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH
				
				case "INTL_RU_PURCHASE"
					HPATH = "\\mossrv02\purchase$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH
'				Adding SAP INI file
					Set fso = CreateObject("Scripting.FileSystemObject")
					Set f2 = fso.GetFile("\\mossrv02\common$\ITdept\saplogon.ini")
					f2.Copy ("c:\WINDOWS\saplogon.ini")

				case "INTL_RU_IT"
					HPATH = "\\mossrv02\IT$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH

				case "INTL_RU_ACCOUNT"
					HPATH = "\\mossrv02\account$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH
'				Adding SAP INI file
					Set fso = CreateObject("Scripting.FileSystemObject")
					Set f2 = fso.GetFile("\\mossrv02\common$\ITdept\saplogon.ini")
					f2.Copy ("c:\WINDOWS\saplogon.ini")

			
				case "INTL_RU_FINANCE"
					HPATH = "\\mossrv02\finance$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH
'				Adding SAP INI file
					Set fso = CreateObject("Scripting.FileSystemObject")
					Set f2 = fso.GetFile("\\mossrv02\common$\ITdept\saplogon.ini")
					f2.Copy ("c:\WINDOWS\saplogon.ini")


				case "INTL_RU_REGISTR"
					HPATH = "\\mossrv02\registr$"
					wshNetwork.RemoveNetworkDrive "S:", true, true
					wshNetwork.MapNetworkDrive "S:", HPATH


				'Ends Queries being performed by select statement
	    		end select

				strUserName =wshNetwork.UserName
				wshNetwork.MapNetworkDrive "P:", "\\mossrv02\" & strUserName & "$"

'Performs next Query of the user account properties for another group membership name
		next




		
'Ends the Subroutine
End Sub

' ******************************************************************************************
' SAP*****.INI-Distribution WINDOWS 2000 *****
objFSO.CopyFile "O:\ITdept\saplogon.ini", "c:\WINNT\saplogon.ini"
objFSO.CopyFile "O:\ITdept\sapmsg.ini", "c:\WINNT\sapmsg.ini" 
objFSO.CopyFile "O:\ITdept\saproute.ini", "c:\WINNT\saproute.ini"  

' SAP*****.INI-Distribution WINDOWS XP *****
objFSO.CopyFile "O:\ITdept\saplogon.ini", "c:\WINDOWS\saplogon.ini"
objFSO.CopyFile "O:\ITdept\sapmsg.ini", "c:\WINDOWS\sapmsg.ini" 
objFSO.CopyFile "O:\ITdept\saproute.ini", "c:\WINDOWS\saproute.ini"  

' ******************************************************************************************
' Cleanup
Set wshNetwork = Nothing
Set WshShell = Nothing 
Set objFSO = Nothing
