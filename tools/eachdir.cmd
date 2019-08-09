@echo off
for /d %i in (C:\temp\*) do ( cd "%i" &  make ) 