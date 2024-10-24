package main

import (
	"fmt"
//	"golang/cource/06e_network/servers"
	"golang/cource/06e_network/clients"
)

func main() {
	fmt.Println("Started test servers.")
//	server.TCPServer()
//	server.UDPServer()
//	client.TCPClient()
	client.UDPClient()
}
