@echo off
rem Simple build programm
REM C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\csc.exe %1
rem C:\WINDOWS\Microsoft.NET\Framework\v3.5\csc.exe test.cs

rem Build DLL
rem C:\WINDOWS\Microsoft.NET\Framework\v3.5\csc.exe /target:library /out:main.dll main.cs

rem Build programm with DLL
rem C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\csc.exe /out:sptest.exe /reference:microsoft.sharepoint.dll sptest.cs
C:\WINDOWS\Microsoft.NET\Framework\v3.5\csc.exe /debug:full /out:tspps3_work.exe /reference:microsoft.sharepoint.dll export_tspps3.cs
rem C:\WINDOWS\Microsoft.NET\Framework\v3.5\csc.exe /debug:full /out:test.exe /reference:microsoft.sharepoint.dll test.cs

rem Build programm with ICON
rem C:\WINDOWS\Microsoft.NET\Framework\v3.5\csc.exe /win32icon:WINUPD.ICO %1

rem Prepare create strings resource file
rem "C:\Program Files\Microsoft SDKs\Windows\v6.0A\bin\resgen.exe" %1
rem Prepare create images resource file
rem ???ResXGen /i:1.bmp /o:Images.resx /n:Image

rem Create resource file
rem "C:\WINDOWS\Microsoft.NET\Framework\v3.5\csc.exe" /res:resource.resources %1

rem Register ActiveX components
rem regsvr32 %1
rem Register Control Wrapper
rem "C:\Program Files\Microsoft SDKs\Windows\v6.0A\bin\aximp.exe" %1

rem Register DLL in Assembly
rem C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322\gacutil.exe /i %1

@exit
