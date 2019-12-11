.DEFAULT_GOAL := help
.PHONY: *

help:
	echo "See Makefile for usage"

build:
	echo "Building Tag: $(TAG)"
	@docker build \
		--no-cache \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		-t scriptor2k2/ci:$(TAG) \
		-f Dockerfile-$(TAG) .

test:
	echo "Testing Tag: $(TAG)"
	dgoss run -it scriptor2k2/ci:$(TAG)

build-all:
	make build TAG="7.0"
	make build TAG="7.1"
	make build TAG="7.2"
	make build TAG="7.3"
	make build TAG="7.4"

test-all:
	make test TAG="7.0"
	make test TAG="7.1"
	make test TAG="7.2"
	make test TAG="7.3"
	make test TAG="7.4"

push-all:
	docker push scriptor2k2/ci:7.0
	docker push scriptor2k2/ci:7.1
	docker push scriptor2k2/ci:7.2
	docker push scriptor2k2/ci:7.3
	docker push scriptor2k2/ci:7.4

	# Tag 7.4 as latest and 7
	docker tag scriptor2k2/ci:7.4 scriptor2k2/ci:7
	docker tag scriptor2k2/ci:7.4 scriptor2k2/ci:latest
	docker push scriptor2k2/ci:7
	docker push scriptor2k2/ci:latest

clean:
	docker ps -a -q | xargs docker rm -f
	docker images -q | xargs docker rmi -f
