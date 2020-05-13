SHELL = bash

DOCKER_REGISTRY ?= 'docker.io'
DOCKER_IMAGE_VERSION ?= 0.7.18.2
DOCKER_IMAGE_NAME = biarms/duplicity
BUILD_DATE ?= `date -u +"%Y-%m-%dT%H-%M-%SZ"`
# See https://microbadger.com/labels
VCS_REF = `git rev-parse --short HEAD`
PLATFORM ?= linux/arm/v7,linux/arm64/v8,linux/amd64

ARCH ?= arm64v8
LINUX_ARCH ?= aarch64
# See https://github.com/docker-library/official-images#architectures-other-than-amd64
# |---------|------------|
# |  ARCH   | LINUX_ARCH |
# |---------|------------|
# |  amd64  |   x86_64   |
# | arm32v6 |   armv6l   |
# | arm32v7 |   armv7l   |
# | arm64v8 |   aarch64  |
# |---------|------------|

# DOCKER_CLI_EXPERIMENTAL = enabled is needed for "docker manifest". See https://docs.docker.com/engine/reference/commandline/manifest/ (at least with 19.03)

default: build-and-tests

check:
	@ which docker > /dev/null || (echo "Please install docker before using this script" && exit 1)
	@ which git > /dev/null || (echo "Please install git before using this script" && exit 1)
	@ DOCKER_CLI_EXPERIMENTAL=enabled docker manifest --help | grep "docker manifest COMMAND" > /dev/null || (echo "docker manifest is needed. Consider upgrading docker" && exit 2)
	@ DOCKER_CLI_EXPERIMENTAL=enabled docker version -f '{{.Client.Experimental}}' | grep "true" > /dev/null || (echo "docker experimental mode is not enabled" && exit 2)
	@ echo "DOCKER_REGISTRY: ${DOCKER_REGISTRY}"
	@ echo "BUILD_DATE: ${BUILD_DATE}"
	@ echo "VCS_REF: ${VCS_REF}"

infra-tests: check
	docker version
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx version

prepare: infra-tests
	DOCKER_CLI_EXPERIMENTAL=enabled docker context create buildx-multi-arch-context
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx create --name=buildx-multi-arch || true
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx use buildx-multi-arch
	@ # From https://github.com/multiarch/qemu-user-static:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

test-arm32v7: check
	ARCH=arm32v7 LINUX_ARCH=armv7l DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION) make -f test-one-image

test-arm64v8: check
	ARCH=arm64v8 LINUX_ARCH=aarch64 DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION) make -f test-one-image

test-amd64: check
	ARCH=amd64 LINUX_ARCH=x86_64 DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION) make -f test-one-image

test-images: test-arm32v7 test-arm64v8 test-amd64
	echo "All tests are OK :)"

build: prepare
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build -f Dockerfile --platform "${PLATFORM}" --tag "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}" --build-arg VERSION="${DOCKER_IMAGE_VERSION}" --build-arg VCS_REF="${VCS_REF}" --build-arg BUILD_DATE="${BUILD_DATE}" .

build-and-tests: prepare test-images build
	echo "Build completed"

build-and-push: prepare test-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build -f Dockerfile --push --platform "${PLATFORM}" --tag "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}" --build-arg VERSION="${DOCKER_IMAGE_VERSION}" --build-arg VCS_REF="${VCS_REF}" --build-arg BUILD_DATE="${BUILD_DATE}" .
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build -f Dockerfile --push --platform "${PLATFORM}" --tag "${DOCKER_IMAGE_NAME}:latest" --build-arg VERSION="${DOCKER_IMAGE_VERSION}" --build-arg VCS_REF="${VCS_REF}" --build-arg BUILD_DATE="${BUILD_DATE}" .
