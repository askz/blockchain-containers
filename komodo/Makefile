VERSION=`cat VERSION`
USERNAME=monaize
IMAGE=komodo
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