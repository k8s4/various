// Simple switch, Cooperative multitasking, preemptive multitasking
// PMG, Processor, Machine, Gorutine -> CPU, thread and gorutine

package main

import ("fmt" 
//	"runtime"
	"time")


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

}

