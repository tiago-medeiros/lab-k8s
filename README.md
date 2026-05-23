# lab-k8s: Kubernetes cluster via KIND + Gateway API + Helm charts

Provisiona um cluster Kubernetes local via KIND com Gateway API (não Ingress) e gerencia deployments via Helm.

## Interface

```bash
make setup      # Cria cluster KIND + instala Gateway API CRDs
make deploy     # Aplica Gateway + charts Helm base
make test       # Valida cluster, gateways e routes
make teardown   # Remove cluster
make validate   # Valida manifests e ferramentas
```

## Arquitetura

```
┌─────────────────────────────────────────────────────┐
│                     KIND Cluster                     │
│                                                      │
│  ┌──────────────┐  ┌──────────────────────────────┐  │
│  │  Gateway API  │  │    platform-lab namespace     │  │
│  │  GatewayClass │──│  ┌─────────┐  ┌───────────┐  │  │
│  │  (envoy)      │  │  │ Gateway │  │HTTPRoute  │  │  │
│  └──────────────┘  │  └─────────┘  └────┬──────┘  │  │
│                     │                    │          │  │
│                     │                    ▼          │  │
│                     │  ┌─────────┐                │  │
│                     └──│backend  │──► port 80      │  │
│                        └─────────┘                │  │
└─────────────────────────────────────────────────────┘
```

## Gateway API vs Ingress

Este domínio utiliza **Gateway API** (`gateway.network.k8s.io/v1`) em vez de Ingress:

- **Gateway API** é a evolução do Ingress API (Kubernetes 1.18+)
- Suporta múltiplos gateways, protocolos (HTTP/HTTPS/TCP/TLS) e attachers
- Modelo explícito de permissão via `ReferenceGrant`
- Melhor separação de responsabilidades entre `GatewayClass`, `Gateway` e `HTTPRoute`

## Variáveis

| Variável       | Descrição            | Padrão         |
|-------|--------|---------|
| `CLUSTER_NAME` | Nome do cluster      | platform-lab |
| `KUBECONFIG`   | Path do kubeconfig   | ./kubeconfig |

## Requisitos

- [Kind](https://kind.sigs.k8s.io/) >= v0.20
- [Helm](https://helm.sh/) >= v3.14
- [kubectl](https://kubernetes.io/docs/reference/kubectl/) >= v1.28
- Gateway API controller (ex: [Envoy Gateway](https://www.envoygateway.io/))

## Notas

- O label `gateway-ready=true` no control-plane indica nodes com Gateway API habilitado
- Os CRDs do Gateway API são instalados automaticamente pelo `make setup`
- Para produção, instale um Gateway controller (Envoy, NGINX Gateway Fabric, etc.) que suporte o Gateway API
