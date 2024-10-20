package main

import (
	"fmt"
	"golang/cource/06a_exec/exec"
)

func main() {
	fmt.Println(exec.Run_simple("ls"))
	fmt.Println(exec.Run_some_std_inout("Test string replace"))
	fmt.Println(exec.Run_with_in_pipe("cat", "Some strange test string by pipe"))
	fmt.Println(exec.Run_with_out_pipe("ping", "-c 1", "8.8.8.8"))
}
