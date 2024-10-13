package main

import (
	"fmt"
	"sync"
	"sync/atomic"
	"time"
)


func addSome(add1 *int, add2 *int32, mu *sync.Mutex) {
	mu.Lock()
	*add1 = *add1 + 1
	mu.Unlock()

	atomic.AddInt32(add2, 1)
}

func main() {
	var some = 0
	var some_atomic int32 = 10

	mu := &sync.Mutex{}

	for i := 1; i <= 1000; i++ {
		go addSome(&some, &some_atomic, mu)
	}

	time.Sleep(1 * time.Second)

	fmt.Println(some, some_atomic)
}

