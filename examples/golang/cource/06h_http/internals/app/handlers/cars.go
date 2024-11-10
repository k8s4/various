package handlers

import (
	"encoding/json"
	"errors"
	"golang/cource/06h_http/internals/app/processors"
	"net/http"
	"strconv"
	"strings"

	"github.com/gorilla/mux"
)

type CarsHandler struct {
	processor *processors.CarsProcessor
}

func NewCarsHandler(processor *processors.CarsProcessor) *CarsHandler {
	handler := new(CarsHandler)
	handler.processor = processor
	return handler
}

func (handler *CarsHandler) Create(response http.ResponseWriter, request *http.Request) {
	var newCar models.Cars
	err := json.NewDecoder(request.Body).Decode(&newCar)
	if err != nil {
		WrapError(response, err)
		return
	}

	err = handler.processor.CreateCar(newCar)
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

func (handler *CarsHandler) List(response http.ResponseWriter, request *http.Request) {
	vars := request.URL.Query()
	var userIdFilter int64 = 0
	if vars.Get("userid") != "" {
		var err error
		userIdFilter, err := strconv.ParseInt(vars.Get("userid"), 10, 64)
		if err != nil {
			WrapError(response, err)
			return
		}
	}
	list, err := handler.processor.ListCars(userIdFilter, strings.Trim(vars.Get("brand"), "\""),
		strings.Trim(vars.Get("colour"), "\""), strings.Trim(vars.Get("license_plate"), "\""))
	if err != nil {
		WrapError(response, err)
	}

	var data = map[string]interface{}{
		"result": "OK",
		"data":   list,
	}

	WrapOK(response, data)
}

func (handler *CarsHandler) Find(response http.ResponseWriter, request *http.Request) {
	vars := mux.Vars(request)
	if vars["id"] == "" {
		WrapError(response, errors.New("Missing ID."))
		return
	}

	id, err := strconv.ParseInt(vars["id"], 10, 64)
	if err != nil {
		WrapError(response, err)
		return
	}

	user, err := handler.processor.FindCar(id)
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
