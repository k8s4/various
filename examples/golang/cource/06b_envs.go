// for more see to go-env library or other
package main

import (
	"fmt"
	"os"
)

func main() {
	os.Setenv("SOME_MY_ENV", "in_the_water")
	fmt.Println("SOME_MY_ENV:", os.Getenv("SOME_MY_ENV"))
	fmt.Println("SEUPER_PASS:", os.Getenv("SUPER_PASS"))
	fmt.Println()

	for _, e := range os.Environ() {
		fmt.Println(e)
	}
}
