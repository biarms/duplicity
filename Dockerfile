FROM python:3

RUN apt-get update && apt-get install -y duplicity

RUN duplicity --version