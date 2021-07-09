package main

import (
	"fmt"
	"log"
	"net/http"
	"orders/controllers"

	"github.com/gorilla/mux"
)

/// Existing code from above
func handleRequests() {
	// creates a new instance of a mux router
	myRouter := mux.NewRouter().StrictSlash(true)

	myRouter.HandleFunc("/healthcheck", controllers.HealthCheckHandler)
	log.Fatal(http.ListenAndServe(":8888", myRouter))
}

func main() {
	fmt.Println("Orders service")
	handleRequests()
}
