SHELL = /usr/bin/env bash -xe

PWD := $(shell pwd)

build:
	@rm -rf layer
	@mkdir layer
	@zip -yr layer/layer.zip files

publish:
	@$(PWD)/publish.sh

.PHONY: \
	build
	publish