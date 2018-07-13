#
# Copyright 2018, TOTVS S.A.
# All rights reserved.
#

SHELL = /bin/bash

# Rule "maven"
.PHONY: maven
maven:
	mvn clean install

# Rule "docker"
.PHONY: docker
docker:
	@for f in *; do \
		if [ -d $${f}/docker ]; then \
			echo $$f; \
			echo "==================================="; \
			cd $$f/docker && make build:local && cd ../..; \
			echo " "; \
		fi \
	done

# Rule "build"
.PHONY: build
build: maven docker

# Rule "gitpull"
.PHONY: gitpull
gitpull:
	@for f in *; do \
		if [ -d $${f}/.git ]; then \
			echo $$f; \
			echo "==================================="; \
			cd $$f && git pull && cd ..; \
			echo " "; \
		fi \
	done

# Rule "gitstatus"
.PHONY: gitstatus
gitstatus:
	@for f in *; do \
		if [ -d $${f}/.git ]; then \
			echo $$f; \
			echo "==================================="; \
			cd $$f && git status && cd ..; \
			echo " "; \
		fi \
	done

# Rule "gitbranch"
.PHONY: gitbranch
gitbranch:
	@for f in *; do \
		if [ -d $${f}/.git ]; then \
			echo $$f; \
			echo "==================================="; \
			cd $$f; \
			var=$$(git branch | grep "*"); \
			echo "$$var"; \
			cd ..; \
			echo ""; \
		fi \
	done

# Rule "run-db"
.PHONY: run-db
run-db:
	cd fluig-demo/docker && docker-compose -f docker-db.yml up

# Rule "run-app"
.PHONY: run-app
run-app:
	cd fluig-demo/docker && docker-compose -f docker-app.yml up
