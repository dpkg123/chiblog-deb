# WIP
# chiblog deb makefile
# Copyright 2023 dabao1955

.PHONY: all

all: install-depends build

install-depends: yarn.lock
	@test -d node_modules || yarn install --frozen-lockfile
build: node_modules/nuxi/bin/nuxi.mjs
	test -d .output || ./node_modules/nuxi/bin/nuxi.mjs build
run: .output/ /usr/bin/node
	node .output/server/index.mjs -p 3000
install: .output/ 
	@test -d /opt/chiblog || mkdir -p -v /opt/chiblog
	@cp .output/* /opt/chiblog || exit 128
docker-run: /usr/bin/docker
	sudo docker run -dit -p 3000:3000 --name my-chiblog-container -e NUXT_CHIBLOG_CONFIG_TYPE=production -e NUXT_CHIBLOG_CONFIG_URL=myurl ghcr.io/chi-net/chiblog
podman-run: /usr/bin/podman
	sudo podman run -dit -p 3000:3000 --name my-chiblog-container -e NUXT_CHIBLOG_CONFIG_TYPE=production -e NUXT_CHIBLOG_CONFIG_URL=myurl ghcr.io/chi-net/chiblog
.PHONY: clean

clean: 
	-rm -rf .output 
dist-clean:
	-rm -rf .output node_modules
