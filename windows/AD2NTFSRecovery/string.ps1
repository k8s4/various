
$pathroot = "c:\share\"
$path = "c:\share\IT\rr\234\234234"

write-host "original: "$path




(($path) -replace ($pathroot -replace "\\", "\\"), "") -replace "\\","_"

((Split-Path $path) -replace ($pathroot -replace "\\", "\\"), "") -replace "\\","_"

translit((get-item $path).name)
	$path2_translit = ""
translit((get-item "$path\..\").name)
	$nameforad = ""
translit($path)

