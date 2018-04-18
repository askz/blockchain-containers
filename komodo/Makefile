# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

VERSION=`cat VERSION`
USERNAME=monaize
IMAGE=komodo
build:  ## Build image monaize/komodo:latest
	 docker build -t ${USERNAME}/${IMAGE}:latest .

pull:
	git pull

patch:
	# bump VERSION
	docker run --rm -v "${PWD}/":/app treeder/bump patch
	echo "VERSION: ${VERSION}"

minor:
	# bump VERSION
	docker run --rm -v "${PWD}/":/app treeder/bump minor
	echo "VERSION: ${VERSION}"

release: patch build ## Build, version, and release to Docker Hub
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