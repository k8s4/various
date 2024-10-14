// Generics from go 1.18

package main

import (
	"fmt"
)

// Type set, Contracts befor 1.18
type Num interface {
	int  | float64
}

func Summa[T Num](a, b T) T {
	return a + b
}

//func Concat[T any, U any](first T, second U) {
func Concat[T any, U any](first T, second U) {
	fmt.Println(first, second)
}

func Distinct[T comparable](list []T) []T {
	uniq := make(map[T]bool)
	var result []T

	for _, i := range list {
		if !uniq[i] {
			uniq[i] = true
			result = append(result, i)
		}
	}
	return result
}

func PrintAny(items []any) {
    for _, item := range items {
        fmt.Printf("%v ", item)
    }
    fmt.Println("")
}


func main() {
	fmt.Println(Summa(5, 4))
	fmt.Println(Summa(3.3, 8.1))
//	fmt.Println(Summa("something", "in the water"))

	Concat(22, "Building number")

	fmt.Println(Distinct([]int{1, 4, 4, 6, 6, 6, 7, 9}))
	fmt.Println(Distinct([]string{"word", "word", "cat", "war", "dog", "people"}))

	PrintAny([]any{1, "some", true, 6.28})

}

