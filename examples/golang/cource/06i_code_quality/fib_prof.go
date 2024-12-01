package main

import (
	"fmt"
	"log"
	"os"
	"runtime/pprof"
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
	fl, err := os.Create("./pprof.out")
	if err != nil {
		log.Fatal()
	}
	defer fl.Close()

	pprof.StartCPUProfile(fl)
	defer pprof.StopCPUProfile()

	n := fib(45)
	fmt.Println(n)
}
