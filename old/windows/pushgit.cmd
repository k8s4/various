@echo off
IF [%2] == [] GOTO usage

git status
git add %1
git status
git commit -m %2
git push
goto exit

:usage
echo ##### Usage:
echo ## %0 "filename|mask" "comment"
echo ## And will get enjoy ;))
echo #####
exit 0

:exit
exit 0
