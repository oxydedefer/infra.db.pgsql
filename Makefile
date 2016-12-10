include env_make
VERSION ?= 01

REPO = postgres_db
NAME = postgres9.5

.PHONY: build push shell run start stop rm release

build:
	docker build -t $(REPO):$(VERSION) .

push:
	docker push $(REPO):$(VERSION)

debug:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION)

stop:
	docker stop $(NAME)-

rm:
	docker rm $(NAME)

release: build
	make push -e VERSION=$(VERSION)

default: build
and don’t forget to place an env_make file next to your Makefile that is ignored by the VCS:

PORTS = -p 5432:5432

VOLUMES = -v postgres:/var/lib/postgresql/data

ENV = \
  -e POSTGRES_USER='toto' \
  -e POSTGRES_PASSWORD='totototo'
