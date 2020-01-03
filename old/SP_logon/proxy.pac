function FindProxyForURL(url, host)
	{
	        if (isPlainHostName(host)||
		    shExpMatch(host, "*.domain.local")||
		    shExpMatch(host, "127.0.0.1")||
		    shExpMatch(host, "10.*.*.*")||
	            shExpMatch(host, "165.179.*.*")||
		    shExpMatch(host, "172.30.48.0"))
	            return "DIRECT";
		if (isPlainHostName(host)||
		    shExpMatch(host, "*.domain.com")||
			return "PROXY 172.16.0.1:3128";
		else
		{
			return "PROXY domain:81; PROXY domain2:81; 10.1.66.63:81"; 
		}
		
	}
