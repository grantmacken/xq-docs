SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -O globstar -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent
include .env
REST_URI := http://localhost:8081/db/
# images
XQ        := ghcr.io/grantmacken/xqerl:$(GHPKG_XQ_VER)
CMARK     := ghcr.io/grantmacken/podx-cmark:$(GHPKG_CMARK_VER)
MAGICK    := ghcr.io/grantmacken/podx-magick:$(GHPKG_MAGICK_VER)
W3M       := ghcr.io/grantmacken/podx-w3m:$(GHPKG_W3M_VER)
ZOPFLI    := ghcr.io/grantmacken/podx-zopfli:$(GHPKG_ZOPFLI_VER)
CSSNANO   := ghcr.io/grantmacken/podx-cssnano:$(GHPKG_CSSNANO_VER)
# xqerl mounts
MountCode        := type=volume,target=/usr/local/xqerl/code,source=xqerl-code
MountData        := type=volume,target=/usr/local/xqerl/data,source=xqerl-database
MountPriv        := type=volume,target=/usr/local/xqerl/lib/xqerl-$(GHPKG_XQ_VER)/priv,source=xqerl-priv
#MountEscripts   := type=volume,target=$(XQERL_HOME)/bin/scripts,source=xqerl-escripts
DASH = printf %60s | tr ' ' '-' && echo
.PHONY: help
help: ## show this help	
	@cat $(MAKEFILE_LIST) | 
	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
	sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

include inc/*.mk

.PHONY: xq-start ## start running xqerl on port 8081
xq-start:
	echo "##[ $(@) ]##"
	podman run --rm --name xq \
		--publish 8081:8081 \
		--mount $(MountCode) --mount $(MountData) --mount $(MountPriv) \
	  --mount type=bind,destination=/usr/local/xqerl/src,source=./src,relabel=shared \
		--detach $(XQ)
	sleep 2
	podman exec xq xqerl eval 'application:ensure_all_started(xqerl).'
	podman exec xq xqerl eval 'file:make_symlink(code:priv_dir(xqerl),"./priv").'

.PHONY: xq-stop
xq-stop: ## stop running xqerl
	@echo "##[ $(@) ]##"
	@if podman ps -a | grep -q $(XQ)
	then
	@podman stop xq || true
	fi

.PHONY: pull-images ## pull docker images
pull-images:
	echo "##[ $(@) ]##"
	podman pull $(XQ)

.PHONY: volumes
volumes:
	@#podman volume exists xqerl-database || podman volume create xqerl-database
	@podman volume exists xqerl-code || podman volume create xqerl-code
	@podman volume exists xqerl-database || podman volume create xqerl-database
	@podman volume exists xqerl-priv || podman volume create xqerl-priv

.PHONY: volumes-clean
volumes-clean:
	@podman volume remove xqerl-code || true
	@podman volume remove xqerl-database || true
	@podman volume remove xqerl-priv || true

.PHONY: docs
docs: src/data/example.com/docs/index.md
	$(MAKE) data
	$(MAKE) code
	bin/documentation $<
	firefox docs/index.html
