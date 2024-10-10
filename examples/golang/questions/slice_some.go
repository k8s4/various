package main

import "fmt"

func main() {
	first := []int{10, 20, 30, 40}
	second := make([]*int, len(first))
	for i, j := range first {
		second[i] = &j
	}
	fmt.Println(*second[0], *second[1])
}

// 40 40
// after go 1.22 = 10 20 30 40
