$Folder = "c:\share"

# Backup
#robocopy.exe $Folder  $($Folder + '_backup') /mir /sec #/xf *

# Restore
#robocopy.exe  "c:\source" $Folder /mir /sec #/xf *

#takeown.exe /A /R /F $Folder

Set-Owner -Path C:\temp -Recurse 
