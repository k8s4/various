// error, waitgroup, channels, select, context

package main

import ("fmt" 
//	"runtime"
	"errors"
	"time")


type error interface {
	Error() string
}


func payloadFunc(num int) {
	fmt.Printf("Started from# %v\n", num)
	var calc int
	for i:=0; i < 100000000; i++ {
		calc = i * num
	}

//	runtime.Gosched()
	fmt.Printf("END# %v: calc = %v\n", num, calc)
}



func main() {
	for i:=1; i <= 5; i++ {
//		payloadFunc(i)
		go payloadFunc(i)
	}

	time.Sleep(100 * time.Millisecond)

// Make error
//	err := errors.New("Some shit error")
//	err := fmt.Errorf("Unsupported error: %T", v)
//	err := fmt.Errorf("Wrapped error: %w", firstErr)

//	prevErr = errors.Unwrap(currentErr)
//	if !errors.Is(err, target) {...}
//	if !errors.As(err, new(*ImportMissingError))) {...}

}

