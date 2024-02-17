all: build

deploy: buildprod builddocker pushdocker

buildprod:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o ./cmd/web/web ./cmd/web
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o ./cmd/api/api ./cmd/api
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o ./cmd/crawler/crawler ./cmd/crawler
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o ./cmd/testcpu/testcpu ./cmd/testcpu
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o ./cmd/testram/testram ./cmd/testram

build:
	go build -o ./cmd/web/web ./cmd/web
	go build -o ./cmd/api/api ./cmd/api
	go build -o ./cmd/crawler/crawler ./cmd/crawler
	go build -o ./cmd/testcpu/testcpu ./cmd/testcpu
	go build -o ./cmd/testram/testram ./cmd/testram

builddocker:
	docker build -t evandolatowski/synergychat-web ./cmd/web
	docker build -t evandolatowski/synergychat-api ./cmd/api
	docker build -t evandolatowski/synergychat-crawler ./cmd/crawler
	docker build -t evandolatowski/synergychat-testram ./cmd/testram
	docker build -t evandolatowski/synergychat-testcpu ./cmd/testcpu

pushdocker:
	docker push evandolatowski/synergychat-web
	docker push evandolatowski/synergychat-api
	docker push evandolatowski/synergychat-crawler
	docker push evandolatowski/synergychat-testram
	docker push evandolatowski/synergychat-testcpu
