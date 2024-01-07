// var, const, pointer
// Types:
// Simple: string, integer, float, boola
//   signed int, int8/16/32/64
//   unsigned uint, uint 8/16/32/64
//   float32/64, 6 and 15 after point
//   complex64/128
//   bool, !, &&, ||
//   string, str[1:2], len(str) in bytes, compare > < ==, data not changed
//     rune==int32, byte==uint8
//
// composite: array, slice, map, struct
//   array: [...]int, string..., len(),  
//   map[key]value like python dict
//   struct - custom data structures
//
// Functions
// func funcName(arg1 string, ...) (res1 int, res2 error, ...) { operators }
// Defer funcName - set down run of func
//
// If some == 1, switch {case a > 1: blabla default: bla}
// For ... for {}, for a == 1 {}, for i;i;i
// for .. range will iterate by chars

package main

import "fmt"


func someFunc(value string) (output string) {
	output = "Your name: " + value
	return
}


func main() {
	const someConst float32 = 3.14
	var someshit, kurwa int = 300, 100

	fmt.Println(someshit)
	fmt.Println(kurwa)

	var x int = 100500
	fmt.Println(x)
	pointer :=  &x
	*pointer = 9
	fmt.Println(x)
// arrays
	var arr1 [5]int = [5]int{1,2,3,4,5}
	var arr2 = [5]int{1,2,3,4,5}
	arr3 := [5]int{1,2,3,4,5}
	arr4 := [...]int{1,2,3,4,5}
	fmt.Println(arr1, arr2, arr3, arr4)
// slices
	var list []int64 = []int64{7,8,8}
	var listt = make([]int64, 0, 5)
	listt = append(listt, 1)
	var l = len(listt)
	var c = cap(listt)
	fmt.Println(list, listt, l, c)
//maps
	var m1 map[int32]bool
	m2 := make(map[string]string)

	ages := map[string]int {
		"Max": 33,
		"Dick": 23,
	}
	ages["Egger"] = 56

	fmt.Println(ages, m1, m2)
// Structure
	type Point struct {
		X int
		Y int
		//Z string
		//T int64
	}
	p := Point {
		X: 5,
		Y: 12,
	}
	p = Point{X:6, Y:13}

	fmt.Println(someFunc("Vasia"), p)
// Defer
	for i := 0; i < 5; i++ {
		defer fmt.Println("Denis: ", i)
	}

	sl := []int64{2,3,4,5}
	for key, value := range sl {
		fmt.Printf("key: %v, val: %v \n", key, value)
	}

}



