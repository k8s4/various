Import-Module activedirectory

$OrganizationUnit  = 'OU=TEST,DC=domain,DC=ru'

# It is display name in AD (attribute cn)
$prefixAD = "RU-MOS-"

# It is display name in Exchange (attribute displayName)
$prefixEX = "RU MOS "

$base = Get-ADGroup -Filter * -SearchBase $OrganizationUnit | ?{$_.GroupCategory -eq "Distribution"}

foreach ($item in $base) {
    $groupname = $item.SamAccountName
    write-host ("!!!Step: " + $groupname)
    $objectAD = (Get-ADGroup $groupname -properties cn)
    if (!($objectAD.Name -like $prefixAD + "*")) {
	Rename-ADObject -Identity $objectAD.DistinguishedName -NewName $($prefixAD + $objectAD.Name)
	write-host ("AD: " + $objectAD.Name + " to " + $($prefixAD + $objectAD.Name))
    }
    $objectEX = (Get-ADGroup $groupname -properties displayName)
    if (!($objectEX.displayName -like $prefixEX + "*")) {
	Set-ADObject -Identity $objectEX.DistinguishedName -replace @{displayName=$($prefixEX + $objectEX.displayName)} 
	write-host ("EX: " + $objectEX.displayName+ " to " + $($prefixEX + $objectEX.displayName))
    }
}
