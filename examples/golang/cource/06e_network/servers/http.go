package server

import (
	"fmt"
	"net/http"
)

func some(writer http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(writer, "Something in the water!\n")
}

func headers(writer http.ResponseWriter, req *http.Request) {
	for name, headers := range req.Header {
		for _, h := range headers {
			fmt.Fprintf(writer, "%v: %v\n", name, h)
		}
	}
}

func HTTPServer() {
	http.HandleFunc("/some", some)
	http.HandleFunc("/headers", headers)

	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println(err)
	}
}
