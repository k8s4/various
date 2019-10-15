BEGIN { 
	FS=":" 
} /.*/ { 
	max = split($2,farray,","); 
	for (i = 1; i <= max - 1; i++) print $1 " " farray[i]; 
}
