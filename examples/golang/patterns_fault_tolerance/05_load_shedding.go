/* Load shedding
Graceful degradation
RateLimit
detect latency for activate ls
Retry-after
*/

type LoadShedder struct {
	semaphore chan struct{}
}

func (ls *LoadShedder) TryProcess(task func()) bool {
	select {
	case ls.semaphore <-struct{}{}:
		go func() {
			defer func() { <-ls.semaphore }()
			task()
		}()
		return true
	default:
		return false
	}
}

func NewLoadSedder(capacity int) *LoadShedder {
	retrun &LoadShedder{
		semaphore: make(chan struct{}, capacity)
	}
}
