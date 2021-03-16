ORG ?=
TAG ?=

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
	sed -i "s,FROM pulp-core,FROM $(ORG)/pulp-core,g" $(IMAGE)/Dockerfile
	cd $(IMAGE) && docker build --cache-from $(ORG)/$(IMAGE):latest -t $(ORG)/$(IMAGE):$(TAG) .

release-%:
	$(eval IMAGE := $(patsubst release-%,%,$@))
	cd $(IMAGE) && docker push $(ORG)/$(IMAGE):$(TAG)
