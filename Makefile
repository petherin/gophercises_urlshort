IMAGE_NAME=petherin/urlshort
IMAGE_TAG=latest

build: ## Builds the local dockerfile
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .
run: ## Runs the container
	docker run --rm -p 8080:8080 --name $(IMAGE_NAME) $(IMAGE_NAME):$(IMAGE_TAG)
