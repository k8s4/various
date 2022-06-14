$Computers = Get-Content "regcomplist.txt"

foreach ($computer in $Computers)
{
	If (test-connection -ComputerName $computer -Count 1 -Quiet)
	{
		$reg = Invoke-Command -ComputerName $computer -ScriptBlock {
			Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Shares\Security
			Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Shares\Security
		}
	}
	else
	{	
		Write-Host "$computer unreachable"
	}
	$computer | export-csv .\Win7VisioStd.csv -append
}
