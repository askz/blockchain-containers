# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help run init create-network

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


run: init ## Fire: docker-compose up
	docker-compose up -d

init: create-network ## Create networks

create-network: ## Create network needed for electrum
	docker network create ext || true

clean: 	## Clean containers, volumes and networks
	@echo -e "\nWARNING: This may touch docker artifacts from other projects than this one! Be cautious!\n"
	docker-compose rm -vsf
	docker volume prune
	docker network prune
