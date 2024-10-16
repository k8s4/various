package main

import "fmt"
import "time"
import "runtime"

func readChan(ch chan int) {
	value := <-ch
	fmt.Println("CHAN VALUE: ", value)
}

func writeChan(ch chan <- int) {
	for i := 1; i <= 5; i++ {
		ch<- i
	}
	close(ch)
}

func writeSelect(ch chan<- int) {
	ch<- 1
}

func readSelect(ch, quit <-chan int) {
	for {
		select {
		case x := <-ch:
			fmt.Println("ch3 = ", x)
		case <-quit:
			fmt.Println("quit")
			return
		default:
			fmt.Println("default")
		}
	}
}

func main() {
	fmt.Println("START MAIN")
	var ch chan int
	var ch2 chan int

// Buffered and unbuffered channel
	ch = make(chan int, 1)
//	ch = make(chan int)

	ch<- 77
	go readChan(ch)
	ch<- 111

	time.Sleep(1 * time.Second)

// for
	ch2 = make(chan int)
	go writeChan(ch2)

	for i := range ch2 {
		fmt.Println("chan i = ", i)
	}

// select 
	ch3 := make(chan int)
	quit := make(chan int)

	go readSelect(ch3, quit)

	go writeSelect(ch3)
	runtime.Gosched()
	go writeSelect(quit)


	fmt.Println("END MAIN")
}
