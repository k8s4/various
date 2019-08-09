Dim WSHShell, FSO, ask_sys_file
set WSHShell = WScript.CreateObject("WScript.Shell")
set FSO = WScript.CreateObject("Scripting.FileSystemObject")

ask_sys_file =  WSHShell.Popup ("Заменить системные файлы(hosts,config.nt)?", 0, "AddSysFile", vbYesNo + vbInformation + vbDefaultButton1)
if ask_sys_file = vbNo Then
    WScript.Quit()
end if
HostFile = "%SystemRoot%\system32\drivers\etc\hosts"
CreateTmpFile HostFile
WriteToFile "192.168.2.14    NFactory-Buh" , HostFile, 8

ConfigFile = "%SystemRoot%\system32\config.nt"
CreateTmpFile ConfigFile
WriteToFile "dos=high, umb" , ConfigFile, 2
WriteToFile "device=%SystemRoot%\system32\himem.sys" , ConfigFile, 8
WriteToFile "files=200" , ConfigFile, 8


function CreateTmpFile(file_name_tmp)
' Требуется обьект fso (Scripting.FileSystemObject)
' Функция для создания резервной копии файла.
'
' file_name_tmp - Полный путь до файла
'
    full_file_tmp = WshShell.ExpandEnvironmentStrings(file_name_tmp)
    if Not (fso.FileExists(full_file_tmp)) Then
        WSHShell.Popup "Файл " + full_folder_path + " не существует.", 0, "CreateTmpFile", vbExclamation
    else
        set file_temp = fso.GetFile (full_file_tmp)
        file_temp.Copy(full_file_tmp + ".tmp")
    end if
end function

function WriteToFile(w_content_file, write_file_name, open_file_type)
' Требуется обьект fso (Scripting.FileSystemObject)
' Функция для записи данных в файл.
'
' w_content_file - Строка данных
' write_file_name - Путь до файла
' open_file_type - Как открывать/создавать
'	1 - Файл открывается только для чтения (!В данной ф-ии не реализовано)
'	2 - Файл открывается для записи. Все содержимое файла, которое было до этого, уничтожится
'	8 - Файл открывается для добавления данных. Все данные будут добавлены в конец файла. Удобно для ведения различных логов
'
    full_file_name = WshShell.ExpandEnvironmentStrings(write_file_name)
    set file = fso.OpenTextFile(full_file_name, open_file_type, true)
    file.WriteLine(w_content_file)
'    file.WriteBlankLines(2)
end function
