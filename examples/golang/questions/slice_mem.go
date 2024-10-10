package main

import "fmt"

func main() {
//	a := make([]int, 0, 10) b = c
	a := make([]int, 0)
	a = append(a, []int{1,2,3,4}...)
	b := append(a, 5)
	c := append(a, 6)

	fmt.Println(a, b, c)
}
