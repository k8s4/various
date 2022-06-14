$WorkingShareFull = "F:\FileServer"
$Levels = 2
$LevelsChar = "\*"


for ($i=0; $i -le $Levels; $i++) {
	if ($i -eq 0) {
		$FullName = get-item $WorkingShareFull | %{ $_.FullName}
	} else {
		$FullName = get-childitem ($WorkingShareFull + $LevelsChar * $i) | ?{$_.PSIsContainer} | %{ $_.FullName}  
	}
	foreach ($FullNameItem in $FullName) {
		if (($FullNameItem.Length - 13) -gt 50) {
			write-host "$FullNameItem"
		}
#		write-host $FullNameItem
	}
}