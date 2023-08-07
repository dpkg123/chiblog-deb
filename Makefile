# WIP
# chiblog deb makefile
# Copyright 2023 dabao1955

.PHONY: all

ifdef test -d node_modules
  all: build
else
  all: install-depends build
endif

install-depends: yarn.lock
	@yarn install --frozen-lockfile
build:
	@yarn run build

run: .output/ /usr/bin/node
	node .output/server/index.mjs -p 3000
docker-run: /usr/bin/docker
	sudo docker run -dit -p 3000:3000 --name my-chiblog-container -e NUXT_CHIBLOG_CONFIG_TYPE=production -e NUXT_CHIBLOG_CONFIG_URL=myurl ghcr.io/chi-net/chiblog
podman-run: /usr/bin/podman
	sudo podman run -dit -p 3000:3000 --name my-chiblog-container -e NUXT_CHIBLOG_CONFIG_TYPE=production -e NUXT_CHIBLOG_CONFIG_URL=myurl ghcr.io/chi-net/chiblog
.PHONY: clean

clean: 
	-rm -rf chiblog/.output 
