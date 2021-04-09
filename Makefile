ORG ?=
TAG ?= latest
DOCKER_BUILDKIT=1

ifeq ($(strip $(ORG)),)
	prefix=
else
	prefix=$(ORG)/
endif

# if we're running from github actions, always cache_from tag latest
ifeq ($(GITHUB_ACTIONS),true)
	cache_tag=latest
else
	cache_tag=$(TAG)
endif

images: build-pulp-core \
        build-pulp-api \
        build-pulp-content \
        build-pulp-resource-manager \
        build-pulp-worker

release: release-pulp-core \
         release-pulp-api \
         release-pulp-content \
         release-pulp-resource-manager \
         release-pulp-worker

build-%:
	$(eval IMAGE := $(patsubst build-%,%,$@))
	cd $(IMAGE) && docker build --build-arg FROM_ORG="$(prefix)" --build-arg FROM_TAG="$(TAG)" --cache-from $(prefix)$(IMAGE):$(cache_tag) -t $(prefix)$(IMAGE):$(TAG) .

release-%:
	$(eval IMAGE := $(patsubst release-%,%,$@))
	cd $(IMAGE) && docker push $(prefix)$(IMAGE):$(TAG)
