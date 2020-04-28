
.PHONY: help

TAG	  ?= 0.0.1
HUB   ?= quay.io/3scale
IMAGE ?= quay.io/3scale/soyuz

help:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null \
		| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
		| egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

build:
	docker build -t $(IMAGE):$(TAG) -f Dockerfile ./ctx

push:
	docker push $(IMAGE):$(TAG)

build-latest: build
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest

push-latest: build-latest
	docker push $(IMAGE):$(TAG)
