package main

import (
	"fmt"
//	"time"
)

func collatzSequence(x int) {
//	fmt.Printf("Collatz sequence for %d\n: ", n)
	n := x
	for n != 1 {
//		fmt.Printf("%d ", n)
		if n % 2 == 0 {
			n = n / 2
		} else {
			n = 3 * n + 1
		}
	}
	fmt.Printf("Finish for %d, last num 1\n", x)
}

func main() {
	var number int = 1000000
	for i := number; i != 1; i-- {
	 	go collatzSequence(i)
	}
}
