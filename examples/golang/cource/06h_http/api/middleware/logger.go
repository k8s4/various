package middleware

import (
	"net/http"

	log "github.com/sirupsen/logrus"
)

func RequestLog(next http.Handler) http.Handler {
	return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		log.Printf("Request: %s Method: %s", request.RequestURI, request.Method)
		next.ServeHTTP(writer, request)
	})
}
