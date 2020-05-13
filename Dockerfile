# 1. Define args usable during the pre-build phase
# BUILD_ARCH: the docker architecture, with a tailing '/'. For instance, "arm64v8/"
ARG BUILD_ARCH

# FROM ${BUILD_ARCH}python:3.8.2-alpine
# RUN apk add duplicity
# RUN duplicity --version
# =>
# Traceback (most recent call last):
#   File "/usr/bin/duplicity", line 31, in <module>
#     from future import standard_library
# ModuleNotFoundError: No module named 'future'

FROM ${BUILD_ARCH}python:3.8.2-slim-buster

RUN apt-get update && apt-get install -y duplicity

RUN duplicity --version