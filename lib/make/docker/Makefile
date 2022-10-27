.PHONY:docker/remove-containers
## Remove all Docker containers
docker/remove-containers:
	docker container stop $(shell docker container ls -aq)
	docker container rm $(shell docker container ls -aq)

.PHONY:docker/remove-images
## Remove all Docker images
docker/remove-images:
	docker image prune --force
	docker images --quiet | xargs docker rmi

.PHONY:docker/remove-volumes
## Remove all Docker volumes
docker/remove-volumes:
	docker volume prune --force
	docker volumes ls | xargs docker volume rm

.PHONY: docker/prune
## Remove unused images and all stopped containers
docker/prune:
	docker system df
	docker image prune --force
	docker container prune --force
