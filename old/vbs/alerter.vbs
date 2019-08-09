'------------------------------------------------------------------------------
'| Alerter - Программа получения данных от пользователей и отправка 
'|           оповещения для удаленного подключения помошников.
'|
'| Processed by uncle Diversant
'------------------------------------------------------------------------------

'Option Explicit
Dim oShell, objWMIService
Dim ok_ip_address, ok_username, ok_host_name, ok_sys_name, ok_sys_sp, ok_mem_tot, ok_mem_ava, ok_reason
Dim SmtpServerName, HeadMessage, MailData, NetData
Set oShell = CreateObject("WScript.Shell")
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")
'-------------------------------------------------------------------------------
SmtpServerName = "mail.domain.local"
HeadMessage = "Отдел Информационных Технологий" + vbCrlf + "Тел. 999-99-99, Мест. 999"
CompileData() ' Получение данных

'------------------------------------------------------------------------------
' Подготовка и отправка письма по почтовым ящикам
'------------------------------------------------------------------------------
MailData = "User name: " + ok_username + vbCrlf + ok_host_name + vbCrlf _
    + ok_ip_address + vbCrlf + ok_sys_name + " " + ok_sys_sp + vbCrlf _
    + ok_mem_tot + vbCrlf + ok_mem_ava + vbCrlf + vbCrlf + ok_reason _
    + vbCrlf + vbCrlf + vbCrlf + vbCrlf + HeadMessage

SendMail "support@domain.local", MailData, "Вызов от пользователя: " & ok_username, SmtpServerName 

'------------------------------------------------------------------------------
' Подготовка и отправка оповещения компьютерам
'------------------------------------------------------------------------------
' Проверка службы сообщений
If Not(QueryServiceState("Messenger") = "Running") Then
    StartService("Messenger")
End If
NetData = "User name: " + ok_username + vbCrlf + ok_host_name _ 
    + vbCrlf + ok_ip_address + vbCrlf _
    + vbCrlf + ok_reason

SendNet "192.168.0.1", NetData

WScript.Echo MailData


'------------------------------------------------------------------------------
' Процедурная, не входить!!!
'------------------------------------------------------------------------------

' Процедура для подготовки информации
Sub CompileData
    Set colSettings = objWMIService.ExecQuery ("Select * from Win32_ComputerSystem")
    For Each objComputer in colSettings 
        ok_username = objComputer.UserName
        ok_host_name =  "Computer name: " & objComputer.Name
        ok_mem_tot =  "Total physical memory: " & FormatNumber(objComputer.TotalPhysicalMemory/1048576, 1) & " Mb"
    Next
    Set colOperatingSystems = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
    For Each objOperatingSystem in colOperatingSystems
        ok_sys_name = objOperatingSystem.Caption & " " & objOperatingSystem.Version
        ok_sys_sp =  "SP: " & objOperatingSystem.ServicePackMajorVersion & "." & objOperatingSystem.ServicePackMinorVersion
        ok_mem_ava =  "Available physical memory: " & FormatNumber(objOperatingSystem.FreePhysicalMemory/1024, 1) & " Mb"
    Next
    Set IPConfigSet = objWMIService.ExecQuery ("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled=TRUE")
    For Each IPConfig in IPConfigSet
        If Not IsNull(IPConfig.IPAddress) Then 
            For i=LBound(IPConfig.IPAddress) to UBound(IPConfig.IPAddress)
                ok_ip_address = ok_ip_address & "IP address " & g & ": " & IPConfig.IPAddress(i) + vbCrlf
            Next
        End If
    Next

' Запрос дополнительной информации
    ok_reason = InputBox("Укажите программу в которой вы работаете и ждите удаленного подключения помошника." _
        + vbCrlf + vbCrlf + vbCrlf + vbCrlf + HeadMessage, "Удаленная помощь", _
        "Опишите свою проблему.", 3000, 3000)
    If ok_reason = "" Then 
        WScript.Quit
    End If
End Sub

' Процедура отправки оповещения
Sub SendNet(sn_computer, sn_message)
    errSendNet = oShell.Run("net send " + sn_computer + " " + sn_message + "", 0, True)
    if errSendNet = 0 Then
        oShell.Popup "Оповещение было отправлено.", 0, "Процедура оповещений", _
            vbOKOnly + vbInformation
        CreateEvent "Отправка оповещения закончилась: ", 0
    Else
  oShell.Popup "Ошибка отправки оповещения.", 0, "Процедура оповещений", _
            vbOKOnly + vbExclamation 
        CreateEvent "Отправка оповещения закончилась: ", 2
    End If
End Sub

' Процедура для отправки писем
Sub SendMail(sm_to, sm_message, sm_title, sm_srv_name)
    Set objEmail = CreateObject("CDO.Message")
    objEmail.Bodypart.Charset = "windows-1251"
    objEmail.From = "support@domain.local"
    objEmail.To = sm_to
    objEmail.Subject = sm_title
    objEmail.Textbody = sm_message
    ' objEmail.AddAttachment "c:\Proba.txt"
    on error resume next
    objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/SendUsing") = 2
    objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = sm_srv_name 
    objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
    objEmail.Configuration.Fields.Update
    objEmail.Send
    If Err.Number then
  oShell.Popup "Не удалось доставить письмо. Сервер не доступен.", _
            0, "Процедура доставки писем", vbOKOnly + vbExclamation 
        CreateEvent "Отправка письма закончилась: ", 2
    Else
        oShell.Popup "Письмо было отправлено.", 0, "Процедура доставки писем", _
            vbOKOnly + vbInformation
        CreateEvent "Отправка письма закончилась: ", 0
    End If
    Set objEmail = Nothing 
End Sub

' Процедура для записи события в системе
Sub CreateEvent(ce_message, event_id)
    if event_id = 0 Then
        ce_action = "удачно"
    Else 
        ce_action = "неудачно"
    End If
    Set objShell = Wscript.CreateObject("Wscript.Shell")
    objShell.LogEvent event_id, ce_message & ce_action & "!" & vbCrlf _
        & vbCrlf & "Удаленный помошник." & vbCrlf & HeadMessage
End Sub

' Функция проверки состояния сервисов
' Возвращает состояния: Running, Stopped, Start Pending...
Function QueryServiceState(service_name)
    Set colMessengerService = objWMIService.ExecQuery ("Select * from Win32_Service where Name='" & service_name & "'")
    For Each objService in colMessengerService    
        QueryServiceState = objService.State
    Next
End Function 

' Процедура для запуска сервисов
' Запускает указанный сервис и сервисы от которых он зависит
Sub StartService(service_name)
    Set colServiceList = objWMIService.ExecQuery _
        ("Select * from Win32_Service where Name='" & service_name & "'")
    For Each objService in colServiceList
        errReturn = objService.StartService()
    Next
    Wscript.Sleep 20000
    Set colServiceList = objWMIService.ExecQuery("Associators of " _
       & "{Win32_Service.Name='" & service_name & "'} Where " _
            & "AssocClass=Win32_DependentService " & "Role=Dependent" )
    For Each objService in colServiceList
        objService.StartService()
    Next
End Sub

