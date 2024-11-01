/* BackPressure
Bufferd channels
increase speed time to time
Async
*/

const maxConcurrentRequests = 3
var backpressureLimiter = make(chan struct{}, maxConcurrentRequests)

func handler(w http.ResponseWriter, r *http.Request) {
	select {
	case backpressureLimiter <-struct{}{}:
		defer func() { <-backpressureLimiter }()
		...
		fmt.Fprintln(w, "Request processed!")
	default:
		http.Error(w, "Server is busy, try later", http.StatusServiceUnavailable)
	}
}

