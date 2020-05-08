# Inspired by https://github.com/jdrouet/docker-on-ci/
BUILDX_VER=v0.4.1
CI_NAME?=local
IMAGE_NAME=biarms/duplicity
VERSION?=latest
PLATFORM=linux/arm/v7,linux/arm64/v8,linux/amd64
DOCKER_REGISTRY?=docker.io/
# ,linux/386

default: prepare build-push

check:
	@if [[ "${PLATFORM}" == "" ]]; then \
		echo 'PLATFORM is unset (MUST BE SET !)' && \
		exit 1; \
	fi
	@if ! docker buildx --help > /dev/null ; then \
		echo "docker buildx plugin is not installed. Please consider running 'make install' " && \
		exit 1; \
	fi

install:
	@if ! docker buildx --help > /dev/null ; then \
	  mkdir -vp ~/.docker/cli-plugins/ ~/dockercache && \
	  curl --silent -L "https://github.com/docker/buildx/releases/download/${BUILDX_VER}/buildx-${BUILDX_VER}.darwin-amd64" > ~/.docker/cli-plugins/docker-buildx && \
	  chmod a+x ~/.docker/cli-plugins/docker-buildx ; \
	fi

prepare: install check
	docker buildx create --use

prepare-old: check
	docker context create old-style || true
	docker buildx create old-style --use || true
	docker context use old-style

build: check
	docker buildx build \
		--platform ${PLATFORM} \
		-t ${IMAGE_NAME}:${VERSION} .

build-push: check
	docker buildx build --push \
		--platform ${PLATFORM} \
		-t ${DOCKER_REGISTRY}${IMAGE_NAME}:${VERSION} .
