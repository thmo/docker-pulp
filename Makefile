ORG ?=
TAG ?= latest
DOCKER_BUILDKIT=1

ifeq ($(strip $(ORG)),)
	prefix=
else
	prefix=$(ORG)/
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
	sed -i -E 's,FROM (.*/)?pulp-core(:.+)?([[:space:]].*)?$$,FROM $(prefix)pulp-core:$(TAG),g' $(IMAGE)/Dockerfile
	cd $(IMAGE) && docker build --cache-from $(prefix)$(IMAGE):latest -t $(prefix)$(IMAGE):$(TAG) .

release-%:
	$(eval IMAGE := $(patsubst release-%,%,$@))
	cd $(IMAGE) && docker push $(prefix)$(IMAGE):$(TAG)
