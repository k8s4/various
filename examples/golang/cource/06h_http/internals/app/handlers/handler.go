package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func WrapError(response http.ResponseWriter, err error) {
	WrapErrorWithStatus(response, err, http.StatusBadRequest)
}

func WrapErrorWithStatus(response http.ResponseWriter, err error, httpStatus int) {
	var data = map[string]string{
		"result": "error",
		"data":   err.Error(),
	}

	res, _ := json.Marshal(data)
	response.Header().Set("Content-Type", "application/json; charset=utf-8")
	response.Header().Set("X-Content-Type-Options", "nosniff")
	response.WriteHeader(httpStatus)
	fmt.Fprintln(response, string(res))
}

func WrapOK(response http.ResponseWriter, data map[string]interface{}) {
	res, _ := json.Marshal(data)
	response.Header().Set("Content-Type", "application/json; charset=utf-8")
	response.WriteHeader(http.StatusOK)
	fmt.Fprintln(response, string(res))
}
