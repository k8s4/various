package main

import "fmt"

func main() {
	c := make(chan int)
	go func() {
		c <- 1
		close(c)
	}()

	fmt.Println(<- c)
}
