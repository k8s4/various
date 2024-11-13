package handlers

import (
	"errors"
	"net/http"
)

func NotFound(response http.ResponseWriter, request *http.Request) {
	WrapErrorWithStatus(response, errors.New("not found Handler"), http.StatusNotFound)
}
