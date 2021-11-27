package middleware

import (
	"context"
	"log"
	"net/http"
	"strings"

	"github.com/google/uuid"
)

func RequestLoggerMiddleWare(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		uuidVal := ""

		if r.Header.Get("TMX-CORRELATION-ID") == "" {
			uuidWithHyphen := uuid.New()
			uuidVal = strings.Replace(uuidWithHyphen.String(), "-", "", -1)

			log.Printf("Unable to find correlation id. Generating one: %s", uuidVal)
		} else {
			uuidVal = r.Header.Get("TMX-CORRELATION-ID")
			log.Printf("Found correlation id in header: %s", uuidVal)
		}

		ctx := context.WithValue(context.Background(), "TMX-CORRELATION-ID", uuidVal)

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
