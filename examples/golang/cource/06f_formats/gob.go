package main

import (
	"fmt"
	"log"
	"bytes"
	"encoding/gob"
)

func EncodeGob() []byte {
	var buf bytes.Buffer
	enc := gob.NewEncoder(&buf)

	m := make(map[string]string)
	m["foo"] = "bar"

	if err := enc.Encode(m); err != nil {
		log.Fatal(err)
	}

	return buf.Bytes()
}

func DecodeGob(input []byte) {
	buf := bytes.NewBuffer(input)
	dec := gob.NewDecoder(buf)

	m := make(map[string]string)

	if err := dec.Decode(&m); err != nil {
		log.Fatal(err)
	}
	fmt.Println(m["foo"])
}

func main() {
	DecodeGob(EncodeGob())
}
