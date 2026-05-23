# lab-k8s

Provisiona um cluster Kubernetes local via KIND e gerencia deployments via Helm.

## Interface

```bash
make setup      # Cria cluster KIND + NGINX ingress
make deploy     # Aplica charts Helm base
make test       # Valida cluster
make teardown   # Remove cluster
make validate   # Valida manifests
```

## Variáveis

| Variável      | Descrição        | Padrão        |
|------ --------|-----------|---------------|
| `CLUSTER_NAME` | Nome do cluster | platform-lab |
| `KUBECONFIG`   | Path do kubeconfig | ./kubeconfig |
