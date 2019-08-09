#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
#Quotas
#BBR;15&MUZ;15&PHE;6&KRS;6&TCF;6&Licenses;6&KAT;2&VRE;15&TECH;10&DKO;6&DALET;10&DESIGN;40&PROMO;30
#$quotas = "ansible;5&dalet;10&devops;100&excel;30&linux;3&mikrotik;5&old;10&php;10&radio;30&temp;1&tools;30&windows;10&zabbix;1000"

$(get-date) | Out-File log.txt -Append

$root = "S:\PRODUCTION"
$design = "S:\DESIGN"
$promo = "S:\PROMO"
$colItems = Get-ChildItem $root | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
foreach ($i in $colItems) {
    $subFolderItems = Get-ChildItem $i.FullName -recurse -force -ErrorAction:SilentlyContinue | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
    $i.Name + ";" + $subFolderItems.sum
}
(Get-Item $design).Name + ";" + (Get-ChildItem $design -Recurse -force -ErrorAction:SilentlyContinue | Measure-Object -Property length -Sum).Sum
(Get-Item $promo).Name + ";" + (Get-ChildItem $promo -Recurse -force -ErrorAction:SilentlyContinue | Measure-Object -Property length -Sum).Sum

$(get-date) | Out-File log.txt -Append