# WIP
# chiblog deb makefile
# Copyright 2023 dabao1955

.PHONY: all
all: build

install-depends: yarn.lock
	@yarn install --frozen-lockfile
build:
	@yarn run build

.PHONY: clean

clean: chiblog/.output
	-rm -rf chiblog/.output 
run: chiblog/.output /usr/bin/node
	node server/index.mjs -p 3000
