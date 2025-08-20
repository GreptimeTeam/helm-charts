HELM_DOCS_VERSION = v1.12.0

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

.PHONY: install-helm-docs
install-helm-docs: ## Install helm-docs tool
	go install github.com/norwoodj/helm-docs/cmd/helm-docs@${HELM_DOCS_VERSION}

.PHONY: docs
docs: install-helm-docs ## Run helm-docs
	$(GOBIN)/helm-docs -c charts/greptimedb-cluster --chart-search-root=charts/greptimedb-cluster --template-files=README.md.gotmpl
	$(GOBIN)/helm-docs -c charts/greptimedb-operator --chart-search-root=charts/greptimedb-operator --template-files=README.md.gotmpl
	$(GOBIN)/helm-docs -c charts/greptimedb-standalone --chart-search-root=charts/greptimedb-standalone --template-files=README.md.gotmpl
	$(GOBIN)/helm-docs -c charts/greptimedb-remote-compaction --chart-search-root=charts/greptimedb-remote-compaction --template-files=README.md.gotmpl

.PHONY: check-docs
check-docs: docs ## Check docs
	@git diff --quiet || \
    (echo "Need to update documentation, please run 'make docs'"; \
	exit 1)

.PHONY: e2e-greptimedb-cluster
e2e-greptimedb-cluster: ## Run greptimedb-cluster e2e tests
	./scripts/e2e/greptimedb-cluster.sh

.PHONY: e2e-greptimedb-standalone
e2e-greptimedb-standalone: ## Run greptimedb-standalone e2e tests
	./scripts/e2e/greptimedb-standalone.sh

.PHONY: e2e
e2e: ## Run e2e tests
	./scripts/e2e/greptimedb-cluster.sh
	./scripts/e2e/greptimedb-standalone.sh

.PHONY: update-crds
update-crds: ## Run update crd
	./scripts/crds/update-crds.sh

.PHONY: upgrade-crds
upgrade-crds: ## Upgrade the crds in the cluster.
	./scripts/crds/upgrade-crds.sh $(CRDS_VERSION)

.PHONY: check-crds
check-crds: update-crds ## Check crd
	@git diff --quiet || \
    (echo "Need to update crds, please run 'make crds'"; \
	exit 1)

# For example: make update-version CHART=${CHART_NAME} VERSION=${IMAGE_TAG}
# make update-version CHART=greptimedb-standalone VERSION=v0.14.2
# make update-version CHART=greptimedb-cluster VERSION=v0.14.2
# make update-version CHART=greptimedb-operator VERSION=v0.2.2
.PHONY: update-version
update-version: ## Run update version
	./scripts/update/update-version.sh $(CHART) $(VERSION)
