package handlers

import (
	"06h_http/internals/app/models"
	"06h_http/internals/app/processors"
	"encoding/json"
	"errors"
	"net/http"
	"strconv"
	"strings"

	"github.com/gorilla/mux"
)

type UsersHandler struct {
	processor *processors.UsersProcessor
}

func NewUsersHandler(processor *processors.UsersProcessor) *UsersHandler {
	handler := new(UsersHandler)
	handler.processor = processor
	return handler
}

func (handler *UsersHandler) Create(response http.ResponseWriter, request *http.Request) {
	var newUser models.User
	err := json.NewDecoder(request.Body).Decode(&newUser)
	if err != nil {
		WrapError(response, err)
		return
	}

	err = handler.processor.CreateUser(newUser)
	if err != nil {
		WrapError(response, err)
		return
	}

	var data = map[string]interface{}{
		"result": "OK",
		"data":   "",
	}

	WrapOK(response, data)
}

func (handler *UsersHandler) List(response http.ResponseWriter, request *http.Request) {
	vars := request.URL.Query()
	list, err := handler.processor.ListUsers(strings.Trim(vars.Get("name"), "\""))
	if err != nil {
		WrapError(response, err)
	}

	var data = map[string]interface{}{
		"result": "OK",
		"data":   list,
	}

	WrapOK(response, data)
}

func (handler *UsersHandler) Find(response http.ResponseWriter, request *http.Request) {
	vars := mux.Vars(request)
	if vars["id"] == "" {
		WrapError(response, errors.New("missing ID"))
		return
	}

	id, err := strconv.ParseInt(vars["id"], 10, 64)
	if err != nil {
		WrapError(response, err)
		return
	}

	user, err := handler.processor.FindUser(id)
	if err != nil {
		WrapError(response, err)
		return
	}

	var data = map[string]interface{}{
		"result": "OK",
		"data":   user,
	}

	WrapOK(response, data)
}
