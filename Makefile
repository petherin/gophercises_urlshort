IMAGE_TAG=latest
IMAGE_NAME=petherin/urlshort
CONTAINER_NAME=urlshort

build: ## Builds the local dockerfile
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .
run: ## Runs the container
	docker run --rm -p 8080:8080 --name $(CONTAINER_NAME) $(IMAGE_NAME):$(IMAGE_TAG)
history: ## Runs Docker image history to show all image layers
	docker image history $(IMAGE_NAME):$(IMAGE_TAG)
help: ## Prints this help
	@grep -E '^[^.]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'

