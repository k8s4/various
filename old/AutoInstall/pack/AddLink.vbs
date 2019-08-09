Dim WSHShell, ask_link
set WSHShell = WScript.CreateObject("WScript.Shell")

'ask_link =  WSHShell.Popup ("Создать ярлыки на Рабочий стол и Избранное?", 0, "AddLink", vbYesNo + vbInformation + vbDefaultButton1)
'if ask_link = vbNo Then
'    WScript.Quit()
'end if
'Ярлыки на рабочий стол
CreateLink "AllUsersDesktop", "Текстовый процессор Word", "C:\Program Files\Microsoft Office\Office", "winword.exe", 0
CreateLink "AllUsersDesktop", "Электронные таблицы Excel", "C:\Program Files\Microsoft Office\Office", "excel.exe", 0
CreateLink "AllUsersDesktop", "Public", "C:", "public", "%SystemRoot%\system32\SHELL32.dll, 9"
' Ярлыки в избранное
CreateUrlLink "Russian Guns", "http://diversant.h1.ru"
CreateUrlLink "Красный Октябрь", "http://www.konfetki.ru"
CreateUrlLink "Рот Фронт", "http://www.rotfront.ru"

function CreateLink(target_path, name_link, source_path, source_name, icon_number)
' Требуется обьект WSHShell (WScript.Shell)
' Функция создания ярлыков.
'
' target_path - Полный путь до папки назначения или 
'	Desktop - Рабочий стол, 
'	Favorites - Избранное, 
'	Fonts - Шрифты,
'	MyDocuments - Мои документы, 
'	NetHood - Сетевое окружение, 
'	PrintHood - Принтеры, 
'	Programs - подменю Программы из меню Пуск,
'	Recent - подменю Документы из меню Пуск, 
'	SendTo - подменю Отправить из контекстного меню файлов, 
'	StartMenu - Главное меню,
'	Startup - Автозагрузка из подменю Программы, 
'	Templates - Шаблоны
'	AllUsersDesktop, AllUsersStartMenu, AllUsersPrograms, AllUsersStartup - 
'	они присутствуют только в WinNT/2000/XP
' name_link - Имя ярлыка
' source_path - Полный путь до запускаемого файла
' source_name - Имя запускаемого файла
' icon_number - Где брать иконку для ярлыка (Цифра или полный путь до файла и указание цифры "C:\winnt.exe, 0")
'
    if isNumeric(icon_number) Then
           icon_path = (source_path & "\" & source_name & ", " & icon_number)
	Else
           icon_path = icon_number
    end if
    desktop_path = WSHShell.SpecialFolders(target_path)
    set MyShortcut = WSHShell.CreateShortcut (desktop_path + "\\" + name_link + ".lnk")
    MyShortcut.TargetPath = WSHShell.ExpandEnvironmentStrings(source_path + "\" + source_name)
    MyShortcut.WorkingDirectory = WSHShell.ExpandEnvironmentStrings(source_path)
'    MyShortcut.HotKey = ("CTRL+ALT+W")
    MyShortcut.WindowStyle = 4
    MyShortcut.IconLocation = WSHShell.ExpandEnvironmentStrings (icon_path)
    MyShortcut.Save()
end function

function CreateUrlLink(name_url, full_url)
' Требуется обьект WSHShell (WScript.Shell)
' Функция для создания URL ссылок в избранном.
'
' name_url - Имя ссылки
' full_url - Полный путь с указанием сервиса (ftp://ftp.kernel.org)
'
    favorites_path = WSHShell.SpecialFolders("Favorites")
    set MyShortcut = WSHShell.CreateShortcut(favorites_path + "\\" + name_url + ".url")
    MyShortcut.TargetPath = WSHShell.ExpandEnvironmentStrings(full_url)
    MyShortcut.Save()
end function
