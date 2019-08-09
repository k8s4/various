Dim SourcePath,TargetPath,TargetFile,ErrorFile,FoldersCount,ErrorCount,FilesCount,FilesSize,dFileName
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objWSHShell = WScript.CreateObject("WScript.Shell")

SourcePath = "http://sharepoint2001.domain.local/wrksps1/Documents"
TargetPath = "d:\Migration"
TargetFolders = TargetPath & "\folders.txt"
TargetFiles = TargetPath & "\files.txt"
WorkLog = TargetPath & "\worklog.txt"

Main()


Sub Main()
	CreateFolder TargetPath
   WriteToFile "Start creating folders structure on: " &DATE&" "&TIME, WorkLog
   WScript.Echo "Start creating folders structure on: " &DATE&" "&TIME
	GetFoldersList SourcePath, TargetFolders
   WriteToFile "Count folders: " & FoldersCount, WorkLog
   WriteToFile "Count errors: " & ErrorCount, WorkLog
   WriteToFile "All list folders in file: " & TargetFolders, WorkLog
   WriteToFile "Format: Short Path|Coordinators1*Coordinators2|Authors|Readers1*Readers2|Approvers|", WorkLog
   WriteToFile "Finished creating folders structure on: " &DATE&" "&TIME, WorkLog

   WriteToFile " ", WorkLog
   WriteToFile "Start creating files structure on: " &DATE&" "&TIME, WorkLog
   WScript.Echo "Start creating files structure on: " &DATE&" "&TIME
	GetFilesList TargetFolders, TargetFiles
	GetFilesSize TargetFiles
   WriteToFile "Count files: " & FilesCount, WorkLog
   WriteToFile "Count errors: " & ErrorCount, WorkLog
   WriteToFile "Files size: " & FilesSize, WorkLog
   WriteToFile "All list files in file: " & TargetFiles, WorkLog
   WriteToFile "Format: Short Path|Title|Author|Description|Size|Keywords1*Keywords2*|", WorkLog
   WriteToFile "Finished creating folders structure on: " &DATE&" "&TIME, WorkLog

   WriteToFile " ", WorkLog
   WriteToFile "Start copying files to hard disk: " &DATE&" "&TIME, WorkLog
   WScript.Echo "Start copying files to hard disk: " &DATE&" "&TIME
   	CopyFiles TargetFiles
   WriteToFile "Count errors: " & ErrorCount, WorkLog
   WriteToFile "All list files work folder: " & TargetPath, WorkLog
   WriteToFile "Finished copying files to hard disk: " &DATE&" "&TIME, WorkLog

   WriteToFile " ", WorkLog
   WriteToFile "Start copying version files to hard disk: " &DATE&" "&TIME, WorkLog
   WScript.Echo "Start copying version files to hard disk: " &DATE&" "&TIME
	CopyVerFiles TargetFiles
   WriteToFile "Count errors: " & ErrorCount, WorkLog
   WriteToFile "All list version files place in main files folder: " & TargetPath, WorkLog
   WriteToFile "Finished version copying files to hard disk: " &DATE&" "&TIME, WorkLog
End Sub







'==================================== Functions =========================================
'=======

Function GetFoldersList(source_path, target_file)
   On Error Resume Next
   Set oF = CreateObject("CDO.KnowledgeFolder")
   If Err.Number <> 0 Then 
	ErrorCount = ErrorCount + 1 
	WriteToFile "===> Error! On: "&DATE&" "&TIME&"; Function: GetFoldersList; ErrorCode: " & Hex(Err.Number) & _
		     "; Source path: " &source_path& "; Reason: " & Err.Description, WorkLog
	src_return = objWSHShell.Popup ("Warning! No require ActiveX components. " &vbCrlf& "To more, see: " & WorkLog, 0, "Warning!", vbExclamation)
	Err.Clear
	WScript.Quit
   End If
   oF.DataSource.Open source_path
'== Check source errors and write to log file
   If Err.Number <> 0 Then 
	ErrorCount = ErrorCount + 1 
	WriteToFile "===> Warning! On: "&DATE&" "&TIME&"; Function: GetFoldersList; ErrorCode: " & Hex(Err.Number) & _
		     "; Source path: " &source_path& "; Reason: " & Err.Description, WorkLog
	src_return = objWSHShell.Popup ("Warning! No source path or can not connect to server. " &vbCrlf& "To more, see: " & WorkLog, 0, "Warning!", vbExclamation)
	Err.Clear
	WScript.Quit
   End If
   On Error Goto 0
   Set oRS = CreateObject("ADODB.Recordset")
   Set oRS = oF.Subfolders
   While Not oRS.EOF
'== Get subfolders in work folder
	current_folder = oRS.Fields("DAV:href")
	fp_len = Len(SourcePath)
'== Delete first part in path
	work_len = Len(current_folder) - fp_len
'== Replace symbols "/" on "\"
	replace_folder = Replace(Right(current_folder, work_len), "/", "\")
	If CreateFolder(TargetPath & replace_folder) <> "Error!" Then
'== Collect folder path and ACL to file
		WriteToFile replace_folder & "|" & FolderACL(current_folder), target_file
		FoldersCount = FoldersCount + 1
	End If
'== Get subfolders in subfolders
	GetFoldersList current_folder, target_file
	oRS.MoveNext
   Wend
End Function

Sub GetFilesList( source_file, target_file )
   Set objFile = objFSO.OpenTextFile(source_file, 1)
   Do Until objFile.AtEndOfStream
	folders_arr = Split(objFile.ReadLine, "|", -1, 1)
'== Replace symbols "/" on "\"
	replace_folder = Replace(SourcePath & folders_arr(0), "\", "/")
	GetFiles replace_folder, target_file
   Loop
   objFile.Close
End Sub

Function GetFiles( source_path, target_file )
	Set oFiles = CreateObject("CDO.KnowledgeFolder")
	oFiles.DataSource.Open source_path
	Set oFilesRS = CreateObject("ADODB.Recordset")
	Set oFilesRS = oFiles.Items
	While Not oFilesRS.EOF
		On Error Resume Next
		Set objTextFile = objFSO.OpenTextFile (target_file, 8, True)	
		If Err.Number <> 0 Then 
			ErrorCount = ErrorCount + 1 
			WriteToFile "===> Error! On: "&DATE&" "&TIME&"; Function: GetFiles; ErrorCode: " & Hex(Err.Number) & _
				     "; Target file: " &target_file& "; Reason: " & Err.Description, WorkLog
	                objTextFile.Close
			Exit Function	
		End If
		On Error Goto 0
		FilesCount = FilesCount + 1
		current_file = oFilesRS.Fields( "DAV:href" )
		fp_len = Len( SourcePath )
		work_len = Len( current_file ) - fp_len
		replace_file = Replace( Right( current_file, work_len ), "/", "\" )
		On Error Resume Next
	   	objTextFile.WriteLine( replace_file & "|" & FileProperties( current_file ))
		If Err.Number <> 0 Then 
			FilesCount = FilesCount - 1
			ErrorCount = ErrorCount + 1 
			WriteToFile "===> Error! On: "&DATE&" "&TIME&"; Function: GetFiles; ErrorCode: " & Hex(Err.Number) & _
				     "; Write target (" &current_file& "); Reason: " & Err.Description, WorkLog
		   	objTextFile.WriteLine( replace_file & "|" )
	                objTextFile.Close
		End If
                objTextFile.Close
		On Error Goto 0
	    oFilesRS.MoveNext
	Wend
End Function

Sub CopyFiles( source_file )
'== Function copying main file
   Set objFile = objFSO.OpenTextFile( source_file, 1 )
   Do Until objFile.AtEndOfStream
	folders_arr = Split( objFile.ReadLine, "|", -1, 1 )
'== Replace symbols "/" on "\"
	sps_file = Replace( SourcePath & folders_arr(0), "\", "/" )
	hard_file = Replace( TargetPath & folders_arr(0), "/", "\" )
	CopyFromSPS sps_file, hard_file
   Loop
   objFile.Close
End Sub

Sub CopyVerFiles( source_file )
'== Function copying version file
   Set objFile = objFSO.OpenTextFile( source_file, 1 )
   Do Until objFile.AtEndOfStream
	CopyVerFiles_Sub objFile.ReadLine
   Loop
   objFile.Close
End Sub

Sub CopyVerFiles_Sub( str_line )
	folders_arr = Split( str_line, "|", -1, 1 )
'== Replace symbols "/" on "\"
	sps_file = Replace( SourcePath & folders_arr(0), "\", "/" )
	hard_file = Replace( TargetPath & folders_arr(0), "/", "\" )
	ver_file = Replace( folders_arr(0), "/", "\" )
	WScript.Echo sps_file
	On Error Resume Next
	Set orgFile = CreateObject("CDO.KnowledgeDocument")
	orgFile.Datasource.Open sps_file
	Set oVersion = CreateObject("CDO.KnowledgeVersion")
	Set oRS = CreateObject("ADODB.Recordset")
	Set oRS = oVersion.VersionHistory( sps_file )
	If Err.Number <> 0 Then
'== Write to Error Log
		ErrorCount = ErrorCount + 1 
		WriteToFile "===> Error! On: "&DATE&" "&TIME& "; Function: CopyVerFiles; ErrorCode: " & Hex(Err.Number) & _
	     	"; Source path: " &sps_file& "; Reason: " & Err.Description, WorkLog
		Err.Clear
		Exit Sub
	End If
	On Error Goto 0
	While Not oRS.EOF
		   Set oFile = CreateObject("CDO.KnowledgeDocument")
		   oFile.Datasource.Open oRS.Fields("DAV:href")
		   Name = oFile.Fields("DAV:Name")
		   VersionC_temp = Replace( oFile.Fields("urn:schemas-microsoft-com:publishing:Comment"), chr(10), "")
		   Comment = Replace( VersionC_temp, chr(13), "")
		   nver_file = Replace( ver_file, orgFile.Fields("DAV:Name"), oFile.Fields("DAV:Name") )
		   dFileName = Name
		   Work_Ext 	= DivDoWhile( dFileName, ")" )
		   Work_Minor 	= DivDoWhile( dFileName, "." )
		   Work_Major	= DivDoWhile( dFileName, "(" )
		   Work_Name	= dFileName
		   If Work_Minor = "0" Then
			Publish = "2"
		   Else
			Publish = "1"
		   End If
		   VersionComments = VersionComments & nver_file & "|" & Publish & "|" & Comment & vbCrlf
		   hard_ver_file = Replace( hard_file, orgFile.Fields("DAV:Name"), oFile.Fields("DAV:Name") )
		   CopyFromSPS oRS.Fields("DAV:href"), hard_ver_file
		   Set oFile = Nothing

	      oRS.MoveNext
	Wend
	If Not VersionComments = "" Then
		WriteToFile VersionComments, hard_file & ".cmt"
	End If
	VersionComments = ""
	Set orgFile = Nothing
End Sub

Function GetFilesSize( source_file )
'== Function copying main file
   size_file = 0
   Set objFile = objFSO.OpenTextFile( source_file, 1 )
   Do Until objFile.AtEndOfStream
	current_size = 0
	folders_arr = Split( objFile.ReadLine, "|", -1, 1)
	On Error Resume Next
	current_size = folders_arr(4)
	If Err.Number <> 0 Then
		current_size = 0
'== Write to Error Log
		WriteToFile "===> Error! On: "&DATE&" "&TIME& "; Function: GetFileSize; ErrorCode: " & Hex(Err.Number) & _
	     	"; Source path: " &folders_arr(0)& "; Reason: " & Err.Description, WorkLog
		Err.Clear
	End If
	On Error Goto 0
	size_file = size_file + current_size
   Loop
   objFile.Close
   FilesSize = FormatNumber(size_file/1048576, 1) & " Mb"
End Function

Function FolderACL(source_obj)
'== Function get ACL on folder
'== Return FolderACL in format:
'== Coordinators1*Coordinators2*|Authors*|Readers1*Readers2*|Approvers*

   Set objFSO = CreateObject("Scripting.FileSystemObject")
   Set oF = CreateObject("CDO.KnowledgeFolder")
   oF.Datasource.Open source_obj
   For Each items_c in oF.Coordinators
   	acl_list = acl_list & items_c & "*"
   Next
   acl_list = acl_list & "|"
   For Each items_a in oF.Authors
   	acl_list = acl_list & items_a & "*"
   Next
   acl_list = acl_list & "|"
   For Each items_r in oF.Readers
   	acl_list = acl_list & items_r & "*"
   Next
   acl_list = acl_list & "|"
   For Each items_ap in oF.Approvers
   	acl_list = acl_list & items_ap & "*"
   Next
   acl_list = acl_list & "|"
'   For Each items_e in oF.Editors
'   	acl_list = acl_list & items_e & "*"
'   Next
   FolderACL =  acl_list
End Function

Function FileProperties( source_obj )
'== Function get Properties on file
'== Return FileProperties in format:
'== Title|Author|Description|Size|Keywords1*Keywords2*|

   Set oFile = CreateObject("CDO.KnowledgeDocument")
   oFile.Datasource.Open source_obj
   On Error Resume Next
   Title = oFile.Title 
   Author = oFile.Author
   Description_temp = Replace( oFile.Description, chr(10), "")
   Description = Replace( Description_temp, chr(13), "")
   Size = oFile.Fields("DAV:getcontentlength")
   For Each items in oFile.Keywords 
	KeyWords = KeyWords + items + "*"
   Next
   On Error Goto 0
   FileProperties = Title & "|" & Author & "|" & Description & "|" & Size & "|" & KeyWords & "|"
End Function

Function CreateFolder(str_folder)
'== Function create folder
'== REQUIRE objFSO object!!!
   If objFSO.FolderExists(str_folder) Then
	ask_return = objWSHShell.Popup ("Folder " &str_folder& " alredy exist." & vbCrlf & "Peress Yes to delete folder.", 0, "Info", vbYesNo + vbInformation + vbDefaultButton1)
	If ask_return = vbYes Then
		objFSO.DeleteFolder(str_folder)
	End If
	If ask_return = vbNo Then
		WScript.Quit()
	End If
   End If
   On Error Resume Next
   WScript.Sleep(100)
   Set objFolder = objFSO.CreateFolder(str_folder)

   If Err.Number <> 0 Then 
'== Write to Error Log
	ErrorCount = ErrorCount + 1
	CreateFolder = "Error!"
	WriteToFile "===> Error! On: "&DATE&" "&TIME& "; Function: CreateFolder; ErrorCode: " & Hex(Err.Number) & _
		     "; Folder path: " &str_folder& "; Reason: " & Err.Description, WorkLog
	Err.Clear
	Exit Function
   End If
   CreateFolder = "Ok"
   On Error Goto 0
End Function

Function CopyFromSPS( source_path, target_path )
'== Function copy file from URL SPS to hard disk
'== source_path - Must contains full path to source file name
'== target_path - Must contains full path to target file name
'== Return variable CopyFromSPS is "Success" or "Error"

	Set oDocSource = CreateObject("CDO.KnowledgeDocument")
	Set oDocTarget = CreateObject("CDO.KnowledgeDocument")
	On Error Resume Next
	oDocSource.DataSource.Open source_path
'== Check source errors and write to log file
	If Err.Number <> 0 Then 
	'== Write to Error Log
		ErrorCount = ErrorCount + 1
		CopyFromSPS = "Error"
		WriteToFile "===> Error! On: "&DATE&" "&TIME& "; Function: CopyFromSPS; ErrorCode: " & Hex(Err.Number) & _
	     	"; Source path: " &source_path& "; Reason: " & Err.Description, WorkLog
		Err.Clear
		Exit Function	
        End If
	oDocSource.OpenStream.SaveToFile target_path
'== Check target errors and write to log file
	If Err.Number <> 0 Then 
	'== Write to Error Log
		ErrorCount = ErrorCount + 1
		CopyFromSPS = "Error"
		WriteToFile "===> Error! On: "&DATE&" "&TIME& "; Function: CopyFromSPS; ErrorCode: " & Hex(Err.Number) & _
	     	"; Target path: " &target_path& "; Reason: " & Err.Description, WorkLog
		Err.Clear
		Exit Function	
        End If
	On Error Goto 0
	oDocSource.OpenStream.Flush 
	CopyFromSPS = "Success"
	WScript.Sleep(100)
End Function

Function WriteToFile(column01, path_dst)
'== Function write to file
'== REQUIRE objFSO object!!!
   On Error Resume Next
   Set objTextFile = objFSO.OpenTextFile (path_dst, 8, True)	
	If Err.Number <> 0 Then 
'== Write to Error Log
		WriteToFile "===> Error! On: "&DATE&" "&TIME& "; Function: WriteToFile; ErrorCode: " & Hex(Err.Number) & _
	     	"; Target path: " &path_dst& "; Reason: " & Err.Description, WorkLog
		Err.Clear
		Exit Function
	End If
   On Error Goto 0
   objTextFile.WriteLine(column01)
   objTextFile.Close
End Function

Function DivDoWhile( work_word, work_char )
   work_len = Len( work_word )
   Do While char_count < work_len
	char_count = char_count + 1 
	chk_char = Mid( StrReverse( work_word ), char_count, 1 )
	If chk_char = work_char Then
		DivDoWhile = StrReverse( Result )
		name_len = work_len - char_count
		dFileName = Left( work_word, name_len )
		Exit Do		
	End If
	Result = Result + chk_char
   Loop
End Function
