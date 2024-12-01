package app

import (
	"06h_http/api"
	"06h_http/api/middleware"
	"06h_http/internals/app/db"
	"06h_http/internals/app/handlers"
	"06h_http/internals/app/processors"
	"06h_http/internals/cfg"
	"context"

	"net/http"
	"time"

	log "github.com/sirupsen/logrus"

	"github.com/jackc/pgx/v4/pgxpool"
)

type AppServer struct {
	config cfg.Cfg
	ctx    context.Context
	srv    *http.Server
	db     *pgxpool.Pool
}

func NewServer(config cfg.Cfg, ctx context.Context) *AppServer {
	server := new(AppServer)
	server.ctx = ctx
	server.config = config
	return server
}

func (server *AppServer) Serve() {
	log.Println("Starting server")
	log.Println(server.config.GetDBString())
	database, err := pgxpool.Connect(server.ctx, server.config.GetDBString())
	if err != nil {
		log.Fatalln(err)
	}
	defer database.Close()

	carsStorage := db.NewCarsStorage(database)
	usersStorage := db.NewUsersStorage(database)

	carsProcessor := processors.NewCarsProcessor(carsStorage)
	usersProcessor := processors.NewUsersProcessor(usersStorage)

	carsHandler := handlers.NewCarsHandler(carsProcessor)
	usersHandler := handlers.NewUsersHandler(usersProcessor)

	routes := api.CreateRoutes(usersHandler, carsHandler)
	routes.Use(middleware.RequestLog)

	server.srv = &http.Server{
		Addr:    ":" + server.config.Port,
		Handler: routes,
	}

	log.Println("Server started.")
	err = server.srv.ListenAndServe()
	if err != nil {
		log.Fatalln(err)
	}
}

func (server *AppServer) Shutdown() {
	log.Println("Server stopped.")

	ctxShutdown, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	server.db.Close()
	defer func() {
		cancel()
	}()
	var err error
	if err = server.srv.Shutdown(ctxShutdown); err != nil {
		log.Fatalf("Server shutdown failed: %v", err)
	}

	log.Println("Server exited properly.")
}
