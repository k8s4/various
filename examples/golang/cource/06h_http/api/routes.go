package api

import (
	"github.com/gorilla/mux"
)

func CreateRoutes(userHandler *hadlers.UserHandler, carHandler *handlers.CarHandler) *mux.Router {
	router := mux.NewRouter()
	router.HandleFunc("/users/create", userHandler.Create).Methods("POST")
	router.HandleFunc("/users/list", userHandler.List).Methods("GET")
	router.HandleFunc("/users/find/{id:[0-9]+}", userHandler.Find).Methods("GET")

	router.HandleFunc("/cars/create", carsHandler.Create).Methods("POST")
	router.HandleFunc("/cars/list", carsHandler.List).Methods("GET")
	router.HandleFunc("/cars/find/{id:[0-9]+}", carsHandler.Find).Methods("GET")

	router.NotFoundHandler = r.NewRoute().HandleFunc(handlers.NotFound).GetHandler()
	return router
}
