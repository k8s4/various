package main

import (
	"fmt"
	"os"
	"io"
	"bufio"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func read(filepath string) string {
	data, err := os.ReadFile(filepath)
	check(err)
	return string(data)
}

func readByBytes(filepath string) {
	file, err := os.Open(filepath)
	check(err)
	defer file.Close()

	buf1 := make([]byte, 7)
	block1, err := file.Read(buf1)
	check(err)
	fmt.Printf("%d bytes: %s\n", block1, string(buf1))

	buf2 := make([]byte, 2)
	_, err = file.Read(buf2)
	check(err)
	fmt.Printf("%v\n", string(buf2))

	offset3, err := file.Seek(6, 0)
	check(err)
	buf3 := make([]byte, 3)
	block3, err := io.ReadAtLeast(file, buf3, 2)
	check(err)
	fmt.Printf("%d bytes @ %d: %s\n", block3, offset3, string(buf3))

	_, err = file.Seek(0, 0)
	check(err)

	reader4 := bufio.NewReader(file)
	buf4, err := reader4.Peek(15)
	check(err)
	fmt.Printf("15 bytes: %s\n", string(buf4))
}

func write(filepath string, data string) {
	buf := []byte(data)
	err := os.WriteFile(filepath, buf, 0644)
	check(err)
}

func writeMore(filepath string) {
	file, err := os.Create(filepath)
	check(err)
	defer file.Close()

	data1 := []byte{115, 111, 109, 101, 10}
	block1, err := file.Write(data1)
	check(err)
	fmt.Println("Wrote %d bytes.\n", block1)

	block2, err := file.WriteString("BlaBlaBla!\n")
	check(err)
	fmt.Println("Wrote %d bytes.\n", block2)

	_ = file.Sync()

	writer3 := bufio.NewWriter(file)
	block3, err := writer3.WriteString("String with Buffered!\n")
	check(err)
	fmt.Println("Wrote %d bytes.\n", block3)


	writer3.Flush()
}

func main() {
	f := "some.txt"

	write(f, "Hello Peter, how are you doing?")
	writeMore(f)

	fmt.Println(read(f))
	
	readByBytes(f)
}
