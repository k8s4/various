$WorkingShareFull = "c:\share"
$Levels = 3
$LevelsChar = "\*"


for ($i=0; $i -le $Levels; $i++) {
	if ($i -eq 0) {
		$FullName = get-item $WorkingShareFull | %{ $_.FullName}
	} else {
		$FullName = get-childitem ($WorkingShareFull + $LevelsChar * $i) | ?{$_.PSIsContainer} | %{ $_.FullName}  
	}
	foreach ($FullNameItem in $FullName) {
		if ($FullNameItem.Length -gt 64) {
			write-host "Warning!!! Folder path $FullNameItem more 64, so I can not create group"
		}
#		write-host $FullNameItem
	}
}

