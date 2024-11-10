package handlers

import (
	"errors"
	"net/http"
)

func NotFound(response http.ResponseWriter, request *http.Request) {
	WrapErrorWithStatus(response, errors.New("Not found Handler"), http.StatusNotFound)
}
