#
# Copyright 2018, TOTVS S.A.
# All rights reserved.
#

SHELL = /bin/bash

# Rule "pom"
.PHONY: pom
pom:
	@echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>" > pom.xml
	@echo "<project xmlns=\"http://maven.apache.org/POM/4.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" >> pom.xml
	@echo "         xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd\">" >> pom.xml
	@echo "    <modelVersion>4.0.0</modelVersion>" >> pom.xml
	@echo "    <groupId>com.fluig</groupId>" >> pom.xml
	@echo "    <artifactId>fluig-nextgen</artifactId>" >> pom.xml
	@echo "    <version>1.0.0-SNAPSHOT</version>" >> pom.xml
	@echo "    <packaging>pom</packaging>" >> pom.xml
	@echo "    <name>Fluig Next Gen</name>" >> pom.xml
	@echo "    <description>Fluig Next Gen</description>" >> pom.xml
	@echo "    <properties>" >> pom.xml
	@echo "        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>" >> pom.xml
	@echo "        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>" >> pom.xml
	@echo "        <maven.compiler.source>1.8</maven.compiler.source>" >> pom.xml
	@echo "        <maven.compiler.target>1.8</maven.compiler.target>" >> pom.xml
	@echo "        <java.version>1.8</java.version>" >> pom.xml
	@echo "    </properties>" >> pom.xml
	@echo "    <modules>" >> pom.xml
	@for f in *; do \
                if [ -f $${f}/pom.xml ]; then \
	            echo "        <module>$$f</module>" >> pom.xml ;\
                fi \
        done
	@echo "    </modules>" >> pom.xml
	@echo "</project>" >> pom.xml

# Rule "maven"
.PHONY: maven
maven:
	mvn clean install

# Rule "maven:monitor"
.PHONY: maven\:monitor
maven\:monitor:
	mvn clean install -Pmonitoring

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

# Rule "build:monitor"
.PHONY: build\:monitor
build\:monitor: maven\:monitor docker

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
