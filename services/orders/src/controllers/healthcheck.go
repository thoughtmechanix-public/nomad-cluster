package controllers

import (
	"encoding/json"
	"net/http"
	"orders/models"
)

func HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	healthCheck := &models.HealthCheck{Message: "Everything is going to be all right", StatusCode: 200}
	json.NewEncoder(w).Encode(healthCheck)
}
