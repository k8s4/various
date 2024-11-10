package main

import (
	"context"
	"os"
	"os/signal"

	log "github.com/sirupsen/logrus"

	"golang/cource/06h_http/internals/app"
	"golang/cource/06h_http/internals/cfg"
)

func main() {
	config := cfg.LoadAndStoreConfig()

	ctx, cancel := context.WithCancel(context.Background())

	ch := make(chan os.Signal, 1)
	signal.Notify(ch, os.Interrupt)

	server := app.NewServer(config, ctx)

	go func() {
		oscall := <-ch
		log.Printf("System call: %+v", oscall)
		server.Shutdown()
		cancel()
	}()

	server.Serve()
}
