package main

import (
	"fmt"
	"time"
)

func main() {
	data := map[string]int{
		"Moscow":	100,
		"Ekat":		70,
	}

	go func() {
		for i := 0; i < 5000; i++ {
			data["Moscow"]++
		}
	}()

	go func() {
		for i := 0; i < 3000; i++ {
			data["Ekat"]++
		}
	}()

	time.Sleep(1 * time.Second)
	fmt.Println("END Game")
}


