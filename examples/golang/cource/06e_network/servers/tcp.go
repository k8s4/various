package server

import (
	"fmt"
	"net"
	"os"
)

func TCPServer() {
	listener, err := net.Listen("tcp", "localhost:1900")
	if err != nil {
		fmt.Println("Bind listener error: ", err.Error())
		os.Exit(1)
	}
	defer listener.Close()
	fmt.Println("Bind on: localhost:1900")
	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Println("Error accepting: ", err.Error())
			os.Exit(1)
		}
		go handleRequest(conn)
	}
}

func handleRequest(conn net.Conn) {
	buf := make([]byte, 1024)

	reqLen, err := conn.Read(buf)
	if err != nil {
		fmt.Println("Error reading: ", err.Error())
	}
	fmt.Println("Some recieved:", reqLen)
	bytesWritten, err := conn.Write([]byte("Something recieved."))
	if err != nil {
		fmt.Println("Error writing: ", err.Error())
	}
	fmt.Printf("Bytes written: %d\n", bytesWritten)
	conn.Close()
}
