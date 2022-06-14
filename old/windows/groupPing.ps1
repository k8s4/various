$ping = New-Object System.Net.Networkinformation.Ping
1..254 | % { $ping.send(“192.168.100.$_”) | select address, status }