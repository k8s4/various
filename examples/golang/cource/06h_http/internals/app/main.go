package app

import (
	"context"
	"golang/cource/06h_http/internals/cfg"
	"log"
	"net/http"

	"github.com/jackc/pgx/v4/pgxpool"
)

type AppServer struct {
	config	cfg.Cfg
	ctx		context.Context
	srv		*http.Server
	db		*pgxpool.Pool
}

func NewServer(config cfg.Cfg, ctx context.Context) *AppServer {
	server := new(AppServer)
	server.ctx = ctx
	server.config = config
	return server
}

func (server *AppServer) Serve() {
	log.Println("Startung server")
	log.Println(server.config.GetDBString())
	server.db, err := pgxpool.Connect(server.ctx, server.config.GetDBString())
	if err != nil {
		log.Fatalln(err)
	}

	carsStorage := db3.NewCarsStorage(server.db)
	usersStorage := db3.NewUsersStorage(server.db)

	carsProcessor := processors.NewCarsProcessor(carsStorage)
	usersProcessor := processors.NewUsersProcessors(usersStorage)

	carsHandler := handlers.NewCarsHandler(carsProcessor)
	usersHandler := handlers.NewUsersHandler(usersProcessor)

	routes := api.CreateRoutes(userHandler, carsHandler)
	routes.Use(middleware.RequestLog)

	server.srv = &http.Server{
		Addr: ":" + server.confg.Port,
		Handler: routes,
	}

	log.Println("Server started.")
	err = server.srv.ListenAndServe()
	if err != nil {
		log.Fatalln(err)
	}

	return
}

func (server *AppServer) sShutdown() {
	log.Println("Server stopped.")

	ctxShutdown, cancel := context.WithTimeout(context.Background(), 5 * time.Second)
	server.db.Close()
	defer func() {
		cancel()
	}()
	var err error
	if err = server.srv.Shutdown(ctxShutdown); err != nil {
		log.Fatalf("Server shutdown failed: %v", err)
	}

	log.Println("Server exited properly.")

	if err == http.ErrServerClosed {
		err = nil
	}
}
