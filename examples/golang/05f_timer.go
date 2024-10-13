package main

import (
	"fmt"
	"time"
)

func someWithTimer(t *time.Timer, q chan int) {
	time.Sleep(1 * time.Second)
	select {
	case <- t.C:
		fmt.Println("Time out")
	case <- q:
		if !t.Stop() {
			<- t.C
		}
		fmt.Println("Timer was stopped")
	default:
		fmt.Println("End function")
	}
}



func main() {
	timer := time.NewTimer(1 * time.Second)
	quit := make(chan int)

	go someWithTimer(timer, quit)

	time.Sleep(2 * time.Second)
}
