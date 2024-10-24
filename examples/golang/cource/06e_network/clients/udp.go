package client

import (
	"fmt"
	"net"
	"bufio"
)

func UDPClient() {
	buf := make([]byte, 1024)
	conn, err := net.Dial("udp", "localhost:1901")
	if err != nil {
		fmt.Printf("Connection error: %v", err)
		return
	}
	fmt.Fprintf(conn, "Some message to UDP server!")
	_, err = bufio.NewReader(conn).Read(buf)
	if err == nil {
		fmt.Printf("Some in buf: %s", buf)
	} else {
		fmt.Printf("Read error: %s", err)
	}
	conn.Close()
}
