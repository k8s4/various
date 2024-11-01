/* Shadow traffic
Better use libs
*/

func handleRequest(w http.ResponseWriter, r *http.Request) {
	resp, err := forwardRequest(primaryServiceURL, r)
	if err != nil {
		http.Error(w, "Err", http.StatusInternalServersError)
		return
	}
	defer resp.Body.Close()
	...
	w.Write(data)
	// Shadow traffic
	go func() {
		_, err := forwardRequest(shadowServiceURL, r)
		if err != nil {
			log.Printf("Err: %v", err)
		}
	}()
}

/* OR Nginx
location / {
	mirror /mirror;
	proxy_pass http://backend;
}

location = /mirror {
	internal;
	proxy_pass http://some_server$request_uri
}
*/
