package main

import (
	"flag"
	"fmt"
)

func main() {
	nameFlag := flag.String("name", "Peter", "a string with animal name")
	ageFlag := flag.Int("age", 34, "an int with age of animal")
	aliveFlag := flag.Bool("alive", true, "a bool about aliveness")

	var somevar string
	flag.StringVar(&somevar, "somevar", "data", "a string var to var!")

	flag.Parse()

	fmt.Println("Name:", *nameFlag)
	fmt.Println("Age:", *ageFlag)
	fmt.Println("Is alive?", *aliveFlag)
	fmt.Println("Somevar", somevar)
	fmt.Println("Next args: ", flag.Args())
}

