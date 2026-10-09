# go

A generic chart to be used for all GoLang microservices

![Version: 1.17.0](https://img.shields.io/badge/Version-1.17.0-informational?style=flat-square)

## Adding the Helm repo

Before installing the chart, you need to add the helm repository

```
$ helm repo add delio https://raw.githubusercontent.com/deliowales/helm-charts-public/gh-pages
```

## Deploying the Chart

To install the chart with the release name `my-release`:
helm install [RELEASE] [CHART] [flags]

Example:
```
$ helm install horizon . --values uat-values.yaml --namespace horizon
```

Once its initially installed, from them on you need to run the `upgrade` command:
helm upgrade [RELEASE] [CHART] [flags]

Example:
```
$ helm upgrade horizon . --values uat-values.yaml --namespace horizon
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| application.args | list | `[]` | Any args that need to be supplied to the `ENTRYPOINT` command. |
| application.env | list | `[]` | Application environment variables. Currently, most of these should be stored in Vault and defined in Terragrunt. |
| application.extraVolumes | list | `[]` |  |
| application.healthcheck.headers | string | `""` |  |
| application.healthcheck.path | string | `""` |  |
| application.image.pullPolicy | string | `"IfNotPresent"` |  |
| application.image.repository | string | `""` | Name of the ECR/ACR repository |
| application.image.tag | string | `"0.0.0"` | Image tag to be pulled |
| application.livenessProbe | object | `{"failureThreshold":"","httpHeaders":[],"initialDelaySeconds":10,"path":"/_/system/liveness","periodSeconds":"","timeoutSeconds":5,"type":"http"}` | Ignored when `deployment.grpc` is true, in which case grpc_health_probe is used. |
| application.livenessProbe.httpHeaders | list | `[]` | Custom headers to set in the request. HTTP allows repeated headers. |
| application.livenessProbe.type | string | `"http"` | Type of liveness healthcheck. `http` or `tcp` |
| application.name | string | `"go"` | Name of the application e.g. Deals |
| application.readOnly | bool | `true` |  |
| application.readinessProbe | object | `{"failureThreshold":"","httpHeaders":[],"initialDelaySeconds":5,"path":"/_/system/readiness","periodSeconds":"","timeoutSeconds":1,"type":"http"}` | Ignored when `deployment.grpc` is true, in which case grpc_health_probe is used. |
| application.readinessProbe.httpHeaders | list | `[]` | Custom headers to set in the request. HTTP allows repeated headers. |
| application.readinessProbe.type | string | `"http"` | Type of readiness healthcheck. `http` or `tcp` |
| application.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Container security context. Defaults suit the standard alpine-based images (user "app"). Distroless images run as 65532. |
| application.startupProbe | object | `{"enabled":false,"failureThreshold":20,"httpHeaders":[],"initialDelaySeconds":0,"path":"/_/system/liveness","periodSeconds":3,"timeoutSeconds":2,"type":"http"}` | Optional startup probe, for apps that need longer to warm up than the liveness probe tolerates. Uses the same shape as the probes below. |
| authorizationPolicy.enabled | bool | `true` |  |
| authorizationPolicy.extraRules | list | `[]` | Additional Istio AuthorizationPolicy rules, appended after the default allow-rule above. Use this to grant narrower access than the blanket rule — e.g. read-only principals on specific paths plus a separate admin rule. |
| aws | object | `{"iam":{"enabled":false,"role":"","rolePrefix":""}}` | IAM Role to allow the application access to AWS resources (e.g. S3, SQS, Lambda) if needed. |
| azure.identity.clientName | string | `""` |  |
| azure.identity.enabled | bool | `false` |  |
| azure.identity.name | string | `""` |  |
| azure.identity.resourceName | string | `""` |  |
| clamAV | object | `{"enabled":false}` | Enable ClamAV. Currently only used by `virus-scanner`. |
| cloud.containerRegistryURL | string | `"1234.ecr.com"` | **Required**: URL for the Container Registry |
| cloud.environment | string | `"uat"` | **Required**: Cloud Environment. `staging-demo` (aws only), `demo`, `staging-production` (azure only) or `production`. |
| cloud.provider | string | `"aws"` | **Required**: Cloud Provider. Either `AWS` or `Azure` |
| cloud.region | string | `"eu-west-1"` | Cloud Region. Only needed for AWS |
| deployment.castaiPodNodeLifecycleOptOut | bool | `true` | Label drained pods with the castai pod-node-lifecycle opt-out. Every published version of that webhook (<= v0.31.0) predates Kubernetes 1.29, strips the native sleep handler from pods at admission, and the API server then rejects them with "must specify a handler type" — a configured drain is undeployable wherever the webhook runs. Only applied when preStopSleepSeconds is set. Trade-off while labelled: CAST AI stops steering those pods between spot and on-demand. Set false once CAST AI ships a fixed webhook. |
| deployment.containerPort | int | `50051` | Port the application listens on. gRPC services conventionally use 50051. |
| deployment.enabled | bool | `true` |  |
| deployment.grpc | bool | `true` | Use gRPC health probes (`/go/bin/grpc_health_probe`) instead of the HTTP/TCP probes configured under `application`. Defaults true: every consumer of this chart predates HTTP support and is a gRPC service. |
| deployment.hpa.enabled | bool | `true` |  |
| deployment.hpa.maxReplicas | int | `10` | Maximum number of replica pods |
| deployment.hpa.minReplicas | int | `3` | Minimum number of replica pods |
| deployment.hpa.targetCPU | int | `70` | Target CPU usage (%) |
| deployment.hpa.targetMemory | int | `70` | Target Memory usage (Mi). Default is `(request+limit) / 2`. Feel free to overwrite that here if necessary. |
| deployment.nodeSelector.labels | object | `{}` | Node labels the pod must match, merged with the toleration label above. `{eks.amazonaws.com/capacityType: ON_DEMAND}` keeps a pod off spot capacity on an EKS managed node group. |
| deployment.nodeSelector.toleration | string | `""` |  |
| deployment.preStopSleepSeconds | string | `""` | Seconds to sleep in a preStop hook, letting in-flight requests drain before the container is signalled. Omitted entirely when unset. |
| deployment.replicaCount | int | `3` | Replica count not considering the HPA |
| deployment.strategy | object | `{}` | RollingUpdate parameters, e.g. `{maxSurge: 1, maxUnavailable: 0}` for zero-downtime rollouts. Omitted entirely when unset. |
| deployment.terminationGracePeriodSeconds | string | `""` | Seconds the kubelet waits between SIGTERM and SIGKILL. A spot interruption notice is 120 seconds, so a workload that must finish its current unit of work needs a value comfortably inside that. Omitted entirely when unset, which leaves Kubernetes' own default of 30. |
| deployment.topologySpreadConstraints | list | `[{"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"},{"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"}]` | Configure Topology Spread Constrains. A constraint carries a single topologyKey, so keeping replicas off one node and out of one availability zone are separate entries — list both. A bare mapping is still accepted for the single-constraint case. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints |
| destinationRule.enabled | bool | `true` |  |
| ingress.enabled | bool | `false` |  |
| ingress.path | string | `""` |  |
| ingress.pathRouted | string | `""` |  |
| istio.mtls.mode | string | `"STRICT"` |  |
| istio.principals | list | `[]` |  |
| istio.proxy.cpu | string | `""` |  |
| istio.proxy.cpuLimit | string | `""` |  |
| istio.proxy.memory | string | `""` |  |
| istio.proxy.memoryLimit | string | `""` |  |
| istio.subsets | list | `[]` |  |
| istio.tls.mode | string | `"ISTIO_MUTUAL"` |  |
| job.annotations | string | `nil` |  |
| job.args | list | `[]` | Args passed to the job container's entrypoint, e.g. `["migrations"]`. |
| job.backoffLimit | int | `2` |  |
| job.enabled | bool | `false` |  |
| job.name | string | `""` |  |
| job.nodeSelector | object | `{"eks.amazonaws.com/capacityType":"ON_DEMAND"}` | Node labels the job pod must match. Defaults to on-demand capacity: a job that cannot be safely retried should not be interrupted, and it runs too briefly to be worth discounting. Set `nodeSelector: null` to lift it — an empty mapping will not, because Helm merges it into the default. |
| job.podAnnotations | object | `{}` | Annotations on the job's **pod** template, e.g. `sidecar.istio.io/inject: "false"` — injection is decided from the pod, not the Job. |
| job.resources.limits.cpu | string | `nil` |  |
| job.resources.limits.memory | string | `""` |  |
| job.resources.requests.cpu | string | `nil` |  |
| job.resources.requests.memory | string | `""` |  |
| job.ttlSecondsAfterFinished | int | `86400` | Seconds a finished job is kept before Kubernetes deletes it, long enough to read its logs after the fact. |
| job.vault.enabled | bool | `true` |  |
| kong.enabled | bool | `false` |  |
| pdb.enabled | bool | `false` |  |
| pdb.maxUnavailable | string | `""` | Pods that may be unavailable at once. Prefer this over `minAvailable` on an autoscaled service: `minAvailable: 1` against three replicas permits losing two, where `maxUnavailable: 1` bounds the loss whatever the replica count moves to. Mutually exclusive with `minAvailable`. |
| pdb.minAvailable | string | `""` | Pods that must stay available during a voluntary disruption. Defaults to 2 when neither this nor `maxUnavailable` is set. Mutually exclusive with it. |
| pdb.unhealthyPodEvictionPolicy | string | `"AlwaysAllow"` | Whether a pod that is running but not Ready may be evicted even when the budget is not met. `AlwaysAllow` stops a crash-looping pod from blocking a node drain; it is not serving traffic, so the budget has nothing to protect. |
| peerAuthentication.enabled | bool | `true` |  |
| service.enabled | bool | `true` |  |
| service.externalDNS.enabled | bool | `false` |  |
| service.externalDNS.host | string | `""` |  |
| service.kong | object | `{"stripPath":""}` | Strip the path defined in Ingress resource and then forward the request to the upstream service. |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.enabled | bool | `true` |  |
| serviceAccount.name | string | `""` | Leave blank to default to the application name |
| serviceEntry.enabled | bool | `false` |  |
| serviceEntry.hosts | list | `[]` |  |
| serviceEntry.location | string | `""` |  |
| serviceEntry.ports | list | `[]` |  |
| vault | object | `{"env":"","role":"","sharedEnv":""}` | Vault configuration |
| vault.env | string | `""` | Environment of the vault. Format: `<< env >>/<< vault name >> |
| vault.role | string | `""` | Role name |
| vault.sharedEnv | string | `""` | Optional path to a platform-wide shared secret (e.g. `<< env >>/data/_shared`). When set, its keys are appended into the same injected `/vault/secrets/env` file after the service's own secret, giving true single-source shared config. |
| virtualService.enabled | bool | `true` |  |
| virtualService.gateways | list | `[]` |  |
| virtualService.hosts | list | `[]` |  |
| virtualService.retries | object | `{}` | Retry policy, e.g. `{attempts: 2, perTryTimeout: 2s}`. Omitted when unset. |
| virtualService.timeout | string | `""` | Per-route request timeout, e.g. `2s`. Omitted entirely when unset. |
