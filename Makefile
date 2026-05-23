# lab-k8s: Kubernetes cluster via KIND + Helm charts
# Creates a local K8s cluster and deploys Helm charts.

KUBECONFIG ?= $(shell pwd)/kubeconfig
KIND_CLUSTER_NAME ?= platform-lab

.PHONY: setup deploy test teardown validate

setup:
	@echo "Setting up lab-k8s..."
	@echo "Creating KIND cluster '${KIND_CLUSTER_NAME}'..."
	kind create cluster \
		--name $(KIND_CLUSTER_NAME) \
		--config kind/cluster-config.yaml \
		--kubeconfig $(KUBECONFIG) || echo "Cluster may already exist."
	kubectl --kubeconfig $(KUBECONFIG) wait --for=condition=Ready nodes --all --timeout=120s
	@echo "Cluster ready."

deploy: setup
	@echo "Deploying Helm charts..."
	helm upgrade --install --create-namespace \
		--namespace platform-lab \
		--values helm/base-values.yaml \
		--kubeconfig $(KUBECONFIG) \
		platform-lab helm/
	@echo "Helm charts deployed!"

test:
	@echo "Testing lab-k8s..."
	kubectl --kubeconfig $(KUBECONFIG) get nodes
	kubectl --kubeconfig $(KUBECONFIG) get namespaces
	kubectl --kubeconfig $(KUBECONFIG) -n platform-lab get all
	@echo "Tests passed!"

teardown:
	@echo "Tearing down lab-k8s..."
	kind delete cluster --name $(KIND_CLUSTER_NAME) 2>/dev/null || true
	rm -f $(KUBECONFIG)
	@echo "K8s torn down!"

validate:
	@echo "Validating lab-k8s..."
	@if ! command -v kind &>/dev/null; then echo "kind not installed"; exit 1; fi
	@if ! command -v helm &>/dev/null; then echo "helm not installed"; exit 1; fi
	@if ! command -v kubectl &>/dev/null; then echo "kubectl not installed"; exit 1; fi
	@echo "All tools available."
