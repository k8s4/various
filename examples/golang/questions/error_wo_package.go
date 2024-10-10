package main

import "fmt"

func handle() error {
	return &selfError{text: "error"}
}

type selfError struct {
	text string
}

//   /- reciever
// if * then just & in use
// if func return interface then use &
func (m *selfError) Error() string {
	return m.text
}

func main() {
	fmt.Println(handle())
}

// interface
// type Error interface {
//	Error() string
//}
