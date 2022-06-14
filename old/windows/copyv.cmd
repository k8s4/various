@echo off
set src="C:\ProgramData\vizrt\Media Sequencer\"
set dst="D:\Archive"
set days="14"

echo F | xcopy /C /Y /Q %src%\default.xml %dst%\default_%date%.xml
forfiles /p %dst% /s /d -%days% /c "cmd /c del @file"