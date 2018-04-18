# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

init: create-volumes create-network fetch-params ## Initialize needed files, docker network and volume
.PHONY: init

run: init ## Fire: docker-compose up
	docker-compose up
.PHONY: run

rund: init ## Fire: docker-compose up -d
	docker-compose up
.PHONY: run

fetch-params: ## Fetch zcash sprout proving keys in zcash-params volume
	docker-compose run komodo-core bash -c "HOME=/home/komodo/ /fetch-params.sh"
.PHONY: fetch-params

create-volumes: ## Create volumes needed for komodo & electrum
	docker volume create zcash-params || true
.PHONY: create-volumes

create-network: ## Create network needed for electrum
	docker network create ext || true
.PHONY: create-network

clean: 	## Clean containers, volumes and networks
	@echo -e "\nWARNING: This may touch docker artifacts from other projects than this one! Be cautious!\n"
	docker-compose rm -vsf
	docker volume prune
	docker network prune
.PHONY: clean

VERSION=`cat VERSION`
USERNAME=monaize
IMAGE=komodo-ac
build:
	 docker build -t ${USERNAME}/${IMAGE}:latest .

patch:
	git pull
	# bump VERSION
	docker run --rm -v "${PWD}/":/app treeder/bump patch
	echo "VERSION: ${VERSION}"

release: patch build ## Release to Docker Hub
	# tag it
	git add -A
	git commit -m "VERSION ${VERSION}"
	git tag -a "${IMAGE}@${VERSION}" -m "VERSION ${VERSION}"
	git push
	git push --tags

	docker tag ${USERNAME}/${IMAGE}:latest ${USERNAME}/${IMAGE}:${VERSION}

	# push it
	docker push ${USERNAME}/${IMAGE}:latest
	docker push ${USERNAME}/${IMAGE}:${VERSION}