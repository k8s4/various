package main

import (
	"fmt"
	"log"
	"os"
	"runtime/trace"
)

func fib(n uint) uint {
	if n == 0 {
		return 0
	} else if n == 1 {
		return 1
	} else {
		return fib(n - 1) + fib(n - 2)
	}
}

func main() {
	fl, err := os.Create("./trace.out")
	if err != nil {
		log.Fatal()
	}
	defer fl.Close()

	trace.Start(fl)
	defer trace.Stop()

	n := fib(45)
	fmt.Println(n)
}
