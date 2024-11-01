/* Graceful shutdown
contexts
SIGTERM
schedule later long tasks
*/
func main() {
	server := &http.Server{
		Addr: "9000",
	}

	go func() {
		sigChan := make(chan os.Signal, 1)
		signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)
		<-sigChan

		shutdownCtx, cancel := context.WithTimeout(context.Background(), 10 * time.Second)
		defer cancel()

		if err := server.Shutdown(shutdownCtx); err != nil {
			log.Fatalf("HTTP shutdown error: %v", err)
		}
	}()

	http.Handle("/", ...)
	if err := server.ListenAndServe(); !errors.Is(err, http.ErrServerClosed) {
		log.Fatalf("HTTP server error: %v", err)
	}
}

