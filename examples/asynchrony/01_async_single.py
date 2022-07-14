# I/O async with socket
# domain:5000

# callbacks
# generators, coroutines
# async await

import socket

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind(("localhost", 5000))
server_socket.listen()

while True:
    print("Before .accept()")
    client_socket, addr = server_socket.accept()        # Blocking function
    print("Connection from: ", addr)

    while True:
        print("Before .recv()")
        request = client_socket.recv(4096)              # Blocking function too

        if not request:
            break
        else:
            response = "Hello world\n".encode()
            client_socket.send(response)

    print("Outside inner while loop")
    client_socket.close()

