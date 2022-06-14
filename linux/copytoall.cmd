@echo off
rem setlocal EnableDelayedExpansion
set workpath=c:\git
for /d %%i in (%workpath%\*) do ( 
 	xcopy /y %workpath%\.gitignore %%i 
 	xcopy /y %workpath%\push.cmd %%i
	cd %%i
	start push.cmd "*" "Added .gitignore"
)

