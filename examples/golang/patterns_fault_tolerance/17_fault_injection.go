/* Fault injection

*/

func handleRequest(w http.ResponseWriter, r *http.Request) {
	if shouldInjectError() {
		http.Error(w, "Simulated", http.StatusInternalServerError)
		return
	}
	if shouldInjectDelay() {
		time.Sleep(time.Second)
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Hello, World!"))
}

//------

func FaultInjectionMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if rand.Intn(5) == 0 {
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			return
		}
		next.ServeHTTP(w, r)
	}()
}

http.Handle("/", FaultInjectionMiddleware(http.HandlerFunc(simulateDelay)))

http.Handle("/", FaultInjectionMiddleware(http.HandlerFunc(handler)))

 
