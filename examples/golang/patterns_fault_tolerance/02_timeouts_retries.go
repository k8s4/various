/* Use timeouts
* Retries
Exponntial backoff
Jitter
Limit retries
*/

func Some() {
	c := &http.Client{
		Transport: &http.Transport{
			Dial: (&net.Dialer{
					Timeout:	30 * time.Second,
					KeepAlive:	30 * time.Second,
			}).Dial,
  			TLSHandshakeTimeout:	10 * time.Second,
	  		ResponseHeaderTimeout:	10 * time.Second,
  			ExpectContinueTimeout:	1 * time.Second,
	  	}
	}

	s := &http.Server{
		ReadTimeout:	5 * time.Second,
		WriteTimeout:	10 * time.Second,
	}
	log.Println(s.ListenAndServe())
}

