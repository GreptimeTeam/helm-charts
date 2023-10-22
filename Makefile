HELM_DOCS_VERSION = v1.11.3

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

.PHONY: install-helm-docs
install-helm-docs: ## Install helm-docs tool
	go install github.com/norwoodj/helm-docs/cmd/helm-docs@${HELM_DOCS_VERSION}

.PHONY: update-docs
update-docs: install-helm-docs ## Run helm-docs
	$(GOBIN)/helm-docs -c charts/greptimedb-cluster --chart-search-root=charts/greptimedb-cluster --template-files=README.md.gotmpl
	$(GOBIN)/helm-docs -c charts/greptimedb-operator --chart-search-root=charts/greptimedb-operator --template-files=README.md.gotmpl
	$(GOBIN)/helm-docs -c charts/greptimedb-standalone --chart-search-root=charts/greptimedb-standalone --template-files=README.md.gotmpl
