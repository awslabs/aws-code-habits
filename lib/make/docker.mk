.PHONY:docker/remove-containers
## Remove all Docker containers
docker/remove-containers:
	docker container stop $(shell docker container ls -aq)
	docker container rm $(shell docker container ls -aq)

.PHONY:docker/remove-images
## Remove all Docker images
docker/remove-images:
	$(call confirm,docker/remove-images will prune dangling images and remove ALL Docker images)
	docker image prune --force
	docker images --quiet | xargs docker rmi

.PHONY:docker/remove-volumes
## Remove all Docker volumes
docker/remove-volumes:
	$(call confirm,docker/remove-volumes will prune and remove ALL Docker volumes — data loss is permanent)
	docker volume prune --force
	docker volumes ls | xargs docker volume rm

.PHONY: docker/prune
## Remove unused images and all stopped containers
docker/prune:
	$(call confirm,docker/prune will remove unused Docker images and all stopped containers)
	docker system df
	docker image prune --force
	docker container prune --force
