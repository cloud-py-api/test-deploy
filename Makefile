.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Welcome to Test-Deploy app. Please use \`make <target>\` where <target> is one of"
	@echo " "
	@echo "  Next commands are only for dev environment with nextcloud-docker-dev!"
	@echo "  "
	@echo "  build-push        build and push release version of image"
	@echo "  build-push-latest build and push dev version of image"
	@echo "  "
	@echo "  run               deploy release of 'Test-Deploy' for Nextcloud 28"
	@echo "  run-debug         deploy dev version of 'Test-Deploy' for Nextcloud 28"

.PHONY: build-push
build-push:
	docker login ghcr.io
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/cloud-py-api/test-deploy:release-cpu --build-arg BUILD_TYPE=cpu .
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/cloud-py-api/test-deploy:release-cuda --build-arg BUILD_TYPE=cuda .
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/cloud-py-api/test-deploy:release-rocm --build-arg BUILD_TYPE=rocm .

.PHONY: build-push-latest
build-push-latest:
	docker login ghcr.io
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/cloud-py-api/test-deploy:latest-cpu --build-arg BUILD_TYPE=cpu .
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/cloud-py-api/test-deploy:latest-cuda --build-arg BUILD_TYPE=cuda .
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ghcr.io/cloud-py-api/test-deploy:latest-rocm --build-arg BUILD_TYPE=rocm .

.PHONY: run
run:
	docker exec master-stable28-1 sudo -u www-data php occ app_api:app:register test-deploy --force-scopes --test-deploy-mode \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/test-deploy/main/appinfo/info.xml

.PHONY: run-latest
run-debug:
	docker exec master-stable28-1 sudo -u www-data php occ app_api:app:register test-deploy --force-scopes --test-deploy-mode \
		--info-xml https://raw.githubusercontent.com/cloud-py-api/test-deploy/main/appinfo/info-latest.xml
