'Процедура записывает отображаемое имя пользователя (Display name) в поле Описание (description)
'объекта пользователь в AD

Sub SetComputerDescription
    Dim objSysInfo, objUser, objComputer
    Dim strUserDN, strComputerDN, strDisplayName

    On Error Resume Next
    Set objSysInfo = CreateObject("ADSystemInfo")
    strUserDN = objSysInfo.UserName
    Set objUser = GetObject("LDAP://" & strUserDN)
    strDisplayName = Right(objUser.Name, Len(objUser.Name) - 3)

    strComputerDN = objSysInfo.ComputerName
    Set objComputer = GetObject("LDAP://" & strComputerDN)
    objComputer.Put "description", strDisplayName
    objComputer.SetInfo
    Set objSysInfo = Nothing
    Set objUser = Nothing
    Set objComputer = Nothing
    On Error GoTo 0
End Sub