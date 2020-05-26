# 1. Define args usable during the pre-build phase
# BUILD_ARCH: the docker architecture, with a tailing '/'. For instance, "arm64v8/"
ARG BUILD_ARCH

ARG SOFTWARE_VERSION

# FROM ${BUILD_ARCH}python:3.8.3-alpine
# RUN apk add duplicity
# RUN duplicity --version
# =>
# Traceback (most recent call last):
#   File "/usr/bin/duplicity", line 31, in <module>
#     from future import standard_library
# ModuleNotFoundError: No module named 'future'

FROM ${BUILD_ARCH}ubuntu:focal

RUN apt-get update && apt-get install -y duplicity=${SOFTWARE_VERSION}*

# A simple smoke test
RUN duplicity --version

ARG BUILD_DATE
ARG VCS_REF
LABEL \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/biarms/duplicity"
