build: 
	export GO111MODULE=on
	cd src && env GOOS=linux go build -ldflags="-s -w" -o ../bin/orders orders.go

clean:
	rm -rf ./bin ./vendor Gopkg.lock
