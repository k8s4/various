// Ratelimiters:

type RateLimiter struct {
	tokens chan struct{}
}

func (rl *RateLimiter) Allow() bool {
	select {
	case <-rl.tokens:
		return true
	default:
		return false
	}
}

func NewRateLimiter(rate int) *RateLimiter {
	rl := &RateLimiter{
		tokens: make(chan struct{}, rate),
	}

	go func() {
		ticker := time.NewTicker(time.Second / time.Duration(rate))
		defer ticker.Stop()

		for range ticker.C {
			select {
			case rl.tokens <- struct{}{}:
			default:
			}
		}
	}()
	return rl
}

