package main

import (
	"fmt"
	"context"
	"time"
)

func sendData(ctx context.Context, num int) {
	timer := time.NewTimer(time.Duration(num) * time.Second)

	select {
	case <-ctx.Done():
		fmt.Printf("Gorutine $%v canceled\n", num)
		return
	case <-timer.C:
		fmt.Printf("Data was send by #%v\n", num)
	}
}

func main() {
	ctx := context.Background()

//	ctxtype, cancel := context.WithCancel(ctx)
	ctxtype, _ := context.WithTimeout(ctx, 2 * time.Second)


	for i := 1; i < 6; i++ {
		go sendData(ctxtype, i)
	}

//	time.Sleep(2 * time.Second)
//	cancel()
	time.Sleep(1 * time.Second)
}
