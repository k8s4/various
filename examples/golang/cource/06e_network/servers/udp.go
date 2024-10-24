package server

import (
	"fmt"
	"net"
)

func sendResponse(conn *net.UDPConn, addr *net.UDPAddr) {
	_, err := conn.WriteToUDP([]byte("Response from server..."), addr)
	if err != nil {
		fmt.Printf("Couldn't send response: %v\n", err)
	}
}

func UDPServer() {
	buf := make([]byte, 2048)
	addr := net.UDPAddr{
		Port: 1901, 
		IP: net.ParseIP("127.0.0.1"),
	}
	listener, err := net.ListenUDP("udp", &addr)
	if err != nil {
		fmt.Printf("Listen UDP error: %v\n", err)
		return
	}
	fmt.Println("listening on localhost:1901.")
	for {
		_, remoteaddr, err := listener.ReadFromUDP(buf)
		fmt.Printf("Buffer recieved: %s", buf)
		if err != nil {
			fmt.Printf("Read UDP error: %v\n", err)
			return
		}
		go sendResponse(listener, remoteaddr)
	}
}
