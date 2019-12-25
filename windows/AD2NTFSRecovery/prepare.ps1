$Folder = "c:\share"

# Backup
#robocopy.exe $Folder  $($Folder + '_backup') /mir /sec /ndl /lev:3 /xf *

# Restore
#robocopy.exe  "c:\source" $Folder /mir /sec /lev:3 /ndl /xf *

#takeown.exe /A /R /F $Folder

Set-Owner -Path C:\temp -Recurse 
