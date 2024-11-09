package app

import (
	"context"
	"golang/cource/06h_http/internals/cfg"
	"log"
	"net/http"

	"github.com/jackc/pgx/v4/pgxpool"
)

type AppServer struct {
	config cfg.Cfg
	ctx    context.Context
	srv    *http.Server
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
	db, err := pgxpool.Connect(server.ctx, server.config.GetDBString())
	if err != nil {
		log.Fatalln(err)
	}
	defer db.Close()

	carsStorage := db3.NewCarsStorage(db)
	usersStorage := db3.NewUsersStorage(db)

	carsProcessor := processors.NewCarsProcessor(carsStorage)
	usersProcessor := processors.NewUsersProcessors(usersStorage)

	carsHandler := handlers.NewCarsHandler(carsProcessor)
	usersHandler := handlers.NewUsersHandler(usersProcessor)

}
