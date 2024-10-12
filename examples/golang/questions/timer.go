package main

import (
	"fmt"
	"time"
	"net/http"
	"context"
)

const contextTimeout = 2 * time.Second

func getSomeSite() string{
	somecode, _ := http.Get("https://httpstat.us/random/200,201,500-504")

	fmt.Printf("%T\n", somecode)
	return somecode.Status
}

func main() {
	ctx := context.Background()
	res, err := getSomeWithContext(ctx)
	if err != nil {
		fmt.Printf("Something went wrong: %v", err.Error())
		return
	}

	fmt.Printf("Code from site: %v\n", res)
}

func getSomeWithContext(ctx context.Context) (string, error) {
	ctx, cancel := context.WithTimeout(ctx, contextTimeout)
	defer cancel()

	ch := make(chan string)

	go func() {
		ch <- getSomeSite()
		close(ch)
	}()

	select {
		case <- ctx.Done():
			return "0", ctx.Err()
		case result := <- ch:
			return result, nil
	}
}
