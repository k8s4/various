/* Circuit breaker
Lib?
Close/Open/HalfOpen
*/
type CircuitBreaker struct {
	failureCount	int
	failureLimit	int
	state			string
	lastFailure		time.Time
	retryTimeout	time.Duration
}

func (cb *CircuitBreaker) Call(fn func() error) error {
	if cb.state == "open" {
		if time.Since(cb.lastFailure) > cb.retryTimeout {
			// Try
			cb.state = "half-open"
		} else {
			return ErrCircuitBreakerIsOpen
		}
	}

	err := fn()
	if err != nil {
		cb.failureCount++
		cb.lastFailure = time.Now()

		if cb.failureCount >= cb.failureLimit {
			cb.state = "open"
		}
		retrun err
	}

	cb.state = "closed"
	cb.failureCount = 0
	retrun nil
}

