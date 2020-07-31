
.PHONY: help

TAG	?= 0.0.3
CI_TAG ?= ci
HUB	?= quay.io/3scale
IMAGE	?= quay.io/3scale/soyuz

help:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null \
		| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
		| egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort

build-all: build build-latest build-$(CI_TAG) build-$(CI_TAG)-latest

push-all: push push-latest push-$(CI_TAG) push-$(CI_TAG)-latest

build:
	docker build -t $(IMAGE):$(TAG) -f Dockerfile .

push:
	docker push $(IMAGE):$(TAG)

build-latest: build
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest

push-latest: build-latest
	docker push $(IMAGE):$(TAG)

build-$(CI_TAG):
	docker build -t $(IMAGE):$(TAG)-$(CI_TAG) -f Dockerfile-$(CI_TAG) .

push-$(CI_TAG):
	docker push $(IMAGE):$(TAG)-$(CI_TAG)

build-$(CI_TAG)-latest: build
	docker tag $(IMAGE):$(TAG)-$(CI_TAG) $(IMAGE):latest

push-$(CI_TAG)-latest: build-latest
	docker push $(IMAGE):$(TAG)
