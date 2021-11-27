package main

import (
	"log"
	"net/http"
	"orders/controllers"
	"orders/middleware"
	"os"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
)

func registerRequests() {
	myRouter := mux.NewRouter()

	myRouter.HandleFunc("/healthcheck", controllers.HealthCheckHandler)
	myRouter.Use(middleware.RequestLoggerMiddleWare)

	myRouter.HandleFunc("/orders/{Id}", controllers.GetOrderByIdHandler)

	loggedRouter := handlers.LoggingHandler(os.Stdout, myRouter)
	log.Fatal(http.ListenAndServe(":8888", loggedRouter))
}

func main() {
	log.Println("Listening on 8888...")
	registerRequests()
}
