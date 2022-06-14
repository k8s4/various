$Folder = "F:\FileServer"

# Backup
#robocopy.exe $Folder  $($Folder + '_backup') /mir /sec /xf *

# Restore
#robocopy.exe  "c:\Share_backup" $Folder /mir /sec /lev:3 #/xf *

#takeown.exe /A /R /F $Folder

#Set-Owner -Path C:\share -Recurse 

# Restore
robocopy.exe  $Folder $($Folder + '_Skel') /mir /sec /lev:4 /ndl /xf *
