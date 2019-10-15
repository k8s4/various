{ 
	split(substr($0,37),farray," "); 
	count[farray[1]]++; 
} 
END { 
	for (ip in count) print ip " : " count[ip]; 
}