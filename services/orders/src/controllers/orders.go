package controllers

import (
	"encoding/json"
	"log"
	"net/http"
	"orders/models"

	"github.com/gorilla/mux"
)

func GetOrderByIdHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("I am handler: %s", r.Context().Value("TMX-CORRELATION-ID"))
	vars := mux.Vars(r)
	log.Printf("Id of order: %s\n", vars["Id"])

	order := &models.Order{
		Id:         "ABC123",
		Name:       "John Carnell",
		TaxAmount:  10.00,
		GrandTotal: 100,
	}

	json.NewEncoder(w).Encode(order)

}
