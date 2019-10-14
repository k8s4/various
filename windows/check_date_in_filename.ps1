#####
## Script for check xml files in folder on present day, tomorrow and after tomorrow between 11pm and 12pm.
#####

$currenttime = (Get-Date).ToString("HH:mm")
$filepath = "PATH"

$channel=[string]$args[0]

function dater($days) {
	return (Get-Date).AddDays($days).ToString("yyyy.MM.dd")
}

function check_file($date){
    Get-ChildItem -Path $filepath -Include $date"_"$channel".xml" -Recurse|Sort-Object LastWriteTime | Select-Object -Last 1 -OutVariable result | Out-Null
    return $result
}

## Check today file  
if (!(check_file(dater(0)))){
        write-host 1
  }
## Check tomorrow file
    elseif (!(check_file(dater(1)))){
        write-host 2
  }
## Check after tomorrow file
    elseif (!(check_file(dater(2))) -and ($currenttime -gt "23:05") -and ($currenttime -lt "23:59")){
        write-host 3
  }
## All are ok
    else{
        write-host 0
}
        