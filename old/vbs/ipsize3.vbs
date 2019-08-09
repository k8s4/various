Dim varCheckSize, strComputer, strFileResult, varCounter
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objWSHShell = WScript.CreateObject("WScript.Shell")
Set objWSHNetwork = WScript.CreateObject("WScript.Network")
strComputer = "."
strFileResult = objWSHNetwork.UserName & "." & objWSHNetwork.ComputerName & ".txt"
varCheckSize = 52428800

CheckFileExist()
GiveIPconfig()
'GiveFreeSpace()
'GiveListFiles()           
WScript.Echo "Script working end." & vbCrlf & "Работа скрипта завершена."

Sub CheckFileExist()
'==== This procedure checked existing file ====' 
   If objFSO.FileExists(strFileResult) Then
      objFSO.DeleteFile(strFileResult)
   End If
End Sub


Sub GiveFreeSpace()
'==== This procedure receive full and free space on hard disks ====' 
   Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)	
   objTextFile.WriteLine("")
   objTextFile.WriteLine("==== Space on hard disks ====")
   objTextFile.Close
   Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)	
   objTextFile.WriteLine("Disk: " & vbTab & "Name: " & vbTab & vbTab & _ 
	 "Type: " & vbTab & "Total:" & vbTab & vbTab & "Free:")
   objTextFile.Close
   On Error Resume Next
   Set objFSO = CreateObject("Scripting.FileSystemObject")
   Set colDrives = objFSO.Drives
   For Each objDrive in colDrives
     If objDrive.DriveType = 2 Then
       Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)	
       objTextFile.WriteLine(objDrive.RootFolder & vbTab & _
   	 objDrive.VolumeName & vbTab & vbTab & _ 
	 objDrive.FileSystem & vbTab & _ 
	 FormatNumber(objDrive.TotalSize/1048576, 1) & "Mb" & vbTab & _
	 FormatNumber(objDrive.AvailableSpace/1048576, 1) & "Mb")
       objTextFile.Close
     End If
   Next
   On Error Goto 0	
End Sub


Sub GiveListFiles()
'==== This procedure receive list big files ====' 
   varCounter = 0
   Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)	
   objTextFile.WriteLine("")
   objTextFile.WriteLine("==== List big files ====")
   objTextFile.Close
   Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

   Set colFiles = objWMIService. _
	ExecQuery("Select * from CIM_DataFile where Drive = 'C:' AND FileSize > " & varCheckSize)
   For Each objFile in colFiles
	strIfTemp = objFile.FileName & "." & objFile.Extension
	strIfTemp2 = objFile.FileName
	' Check pagefile.sys and clear it on log file

    	If strIfTemp = "pagefile.sys" Then
	ElseIf strIfTemp = "driver.cab" Then
	ElseIf strIfTemp = "objects.data" Then
	ElseIf strIfTemp2 = "objects.data" Then
	Else
           varTemp = objFile.FileSize
           varCounter = varCounter + varTemp
  
	   Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)
	   objTextFile.WriteLine(FormatNumber(objFile.FileSize/1048576, 1) & "Mb" & vbTab & "# " & objFile.Name)
	   objTextFile.Close
	End If
   Next
   Set colFiles = objWMIService. _
	ExecQuery("Select * from CIM_DataFile where Drive = 'D:' AND FileSize > " & varCheckSize)
   For Each objFile in colFiles
	strIfTemp = objFile.FileName & "." & objFile.Extension
	' Check pagefile.sys and clear it on log file

    	If strIfTemp = "pagefile.sys" Then
	ElseIf strIfTemp = "driver.cab" Then
	ElseIf strIfTemp = "objects.data" Then
	ElseIf objFile.FileName = "objects.data" Then
	Else
           varTemp2 = objFile.FileSize
           varCounter = varCounter + varTemp2
	   Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)
	   objTextFile.WriteLine(FormatNumber(objFile.FileSize/1048576, 1) & "Mb" & vbTab & "# " & objFile.Name)
	   objTextFile.Close
	End If
   Next
   Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)
   objTextFile.WriteLine("")
   objTextFile.WriteLine("Total size big files: " & FormatNumber(varCounter/1048576, 1) & "Mb")
   objTextFile.Close
End Sub


Sub GiveIPconfig()
'==== This procedure receive IP configuration  ==== 
Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)	
objTextFile.WriteLine("==== IP Configuration ====")
objTextFile.WriteLine("")
objTextFile.Close

Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colAdapters = objWMIService.ExecQuery _
    ("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True")
 
n = 1
 
For Each objAdapter in colAdapters
   Set objTextFile = objFSO.OpenTextFile (strFileResult, 8, True)
   On Error Resume Next
   objTextFile.WriteLine("Network Adapter " & n & vbCrlf & "=================" _
   & vbCrlf & "  Description: " & objAdapter.Description _
   & vbCrlf & "  Physical (MAC) address: " & objAdapter.MACAddress _
   & vbCrlf & "  Host name:              " & objAdapter.DNSHostName)
	If err then
	    objTextFile.WriteLine("::Error full retrieve General information")
	End If
   On Error Goto 0	
   On Error Resume Next
   If Not IsNull(objAdapter.IPAddress) Then
      For i = 0 To UBound(objAdapter.IPAddress)
   objTextFile.WriteLine("  IP address:             " & objAdapter.IPAddress(i))
      Next
   End If
   If Not IsNull(objAdapter.IPSubnet) Then
      For i = 0 To UBound(objAdapter.IPSubnet)
   objTextFile.WriteLine("  Subnet:                 " & objAdapter.IPSubnet(i))
      Next
   End If
   If Not IsNull(objAdapter.DefaultIPGateway) Then
      For i = 0 To UBound(objAdapter.DefaultIPGateway)
   objTextFile.WriteLine("  Default gateway:        " & objAdapter.DefaultIPGateway(i))
      Next
   End If
	If err then
	    objTextFile.WriteLine("::Error full retrieve IP configuration")
	End If
   On Error Goto 0	
   On Error Resume Next
   objTextFile.WriteLine("  DNS" & vbCrlf & "  ---" & vbCrlf & "    DNS servers in search order:")
 
   If Not IsNull(objAdapter.DNSServerSearchOrder) Then
      For i = 0 To UBound(objAdapter.DNSServerSearchOrder)
   objTextFile.WriteLine("      " & objAdapter.DNSServerSearchOrder(i))
      Next
   End If
 
   objTextFile.WriteLine("    DNS domain: " & objAdapter.DNSDomain)
 
   If Not IsNull(objAdapter.DNSDomainSuffixSearchOrder) Then
      For i = 0 To UBound(objAdapter.DNSDomainSuffixSearchOrder)
   objTextFile.WriteLine("    DNS suffix search list: " & objAdapter.DNSDomainSuffixSearchOrder(i))
      Next
   End If
	If err then
	    objTextFile.WriteLine("::Error full retrieve DNS configuration")
	End If
   On Error Goto 0	
   On Error Resume Next
   objTextFile.WriteLine("  DHCP" & vbCrlf & "  ----" _
   & vbCrlf & "    DHCP enabled:        " & objAdapter.DHCPEnabled _
   & vbCrlf & "    DHCP server:         " & objAdapter.DHCPServer)
 
   If Not IsNull(objAdapter.DHCPLeaseObtained) Then
      utcLeaseObtained = objAdapter.DHCPLeaseObtained
      strLeaseObtained = WMIDateStringToDate(utcLeaseObtained)
   Else
      strLeaseObtained = ""
   End If
   objTextFile.WriteLine("    DHCP lease obtained: " & strLeaseObtained)
 
   If Not IsNull(objAdapter.DHCPLeaseExpires) Then
      utcLeaseExpires = objAdapter.DHCPLeaseExpires
      strLeaseExpires = WMIDateStringToDate(utcLeaseExpires)
   Else
      strLeaseExpires = ""
   End If
   objTextFile.WriteLine("    DHCP lease expires:  " & strLeaseExpires)
	If err then
	    objTextFile.WriteLine("::Error full retrieve DHCP configuration")
	End If
   On Error Goto 0	
   objTextFile.WriteLine("  WINS" & vbCrlf & "  ----" _
	& vbCrlf & "    Primary WINS server:   " & objAdapter.WINSPrimaryServer _
   	& vbCrlf & "    Secondary WINS server: " & objAdapter.WINSSecondaryServer & vbCrlf)
 
   n = n + 1

' Write data to file
   objTextFile.Close

Next
End Sub


Function WMIDateStringToDate(utcDate)
'==== This function for GiveIPconfig() function ====
   WMIDateStringToDate = CDate(Mid(utcDate, 5, 2)  & "/" & _
       Mid(utcDate, 7, 2)  & "/" & _
           Left(utcDate, 4)    & " " & _
               Mid (utcDate, 9, 2) & ":" & _
                   Mid(utcDate, 11, 2) & ":" & _
                      Mid(utcDate, 13, 2))
End Function


