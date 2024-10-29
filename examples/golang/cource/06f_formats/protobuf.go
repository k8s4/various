package main

/*
Some preparations:
sudo apt install protobuf-compiler
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go get google.golang.org/protobuf/proto
go get google.golang.org/protobuf/reflect/protoreflec
go get google.golang.org/protobuf/runtime/protoimpl
protoc person.proto --go_out=./
*/

import (
	"fmt"
	"log"
	"golang/cource/06f_formats/examples/gen"
	"google.golang.org/protobuf/proto"
)

func ProtobufCase() {
	pedro := gen.Person{
		Name: "Pedro",
		Age: 43,
	}

	data, err := proto.Marshal(&pedro)
	if err != nil {
		log.Fatal("Marshaling error: %v", err)
	}

	fmt.Println(data)

	otherPedro := &gen.Person{}
	err = proto.Unmarshal(data, otherPedro)
	if err != nil {
		log.Fatal("Unmarshaling error: %v", err)
	}

	fmt.Println(otherPedro.GetName())
	fmt.Println(otherPedro.GetAge())
}


func main() {
	ProtobufCase()
}
