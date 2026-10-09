# node

A generic chart to be used for all nodeJS microservices

![Version: 1.19.0](https://img.shields.io/badge/Version-1.19.0-informational?style=flat-square)

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
| application.livenessProbe.httpHeaders | list | `[]` | Custom headers to set in the request. HTTP allows repeated headers. |
| application.livenessProbe.path | string | `"/_/system/liveness"` |  |
| application.livenessProbe.port | int | `3000` |  |
| application.livenessProbe.type | string | `"http"` | Type of liveness healthcheck. `http` or `tcp` |
| application.migrations.args | string | `"migrations"` |  |
| application.migrations.backoffLimit | int | `2` |  |
| application.migrations.enabled | bool | `false` |  |
| application.migrations.nodeSelector | object | `{"eks.amazonaws.com/capacityType":"ON_DEMAND"}` | Node labels the migration pod must match. Defaults to on-demand capacity: a kill mid-DDL is the one failure in the estate that needs a human, and the job runs for seconds. Set `nodeSelector: null` to lift it — an empty mapping will not, because Helm merges it into the default. |
| application.migrations.resources.limits.cpu | int | `1` |  |
| application.migrations.resources.limits.memory | string | `"1G"` |  |
| application.migrations.resources.requests.cpu | string | `"500m"` |  |
| application.migrations.resources.requests.memory | string | `"500M"` |  |
| application.migrations.restartPolicy | string | `"OnFailure"` |  |
| application.migrations.ttlSecondsAfterFinished | int | `86400` | Seconds a finished job is kept before Kubernetes deletes it, long enough to read its logs after the fact. |
| application.name | string | `"node"` | Name of the application e.g. Deals |
| application.nodeOptions.maxHttpHeaderSize | int | `65536` | Max HTTP header size in bytes (default: 65536) |
| application.nodeOptions.maxOldSpaceSize | string | `nil` | Max old space size in MB for V8 heap (optional, e.g. 1150) |
| application.ports.containerPort | int | `3000` |  |
| application.readinessProbe.failureThreshold | int | `15` |  |
| application.readinessProbe.httpHeaders | list | `[]` | Custom headers to set in the request. HTTP allows repeated headers. |
| application.readinessProbe.initialDelaySeconds | int | `3` |  |
| application.readinessProbe.path | string | `"/_/system/readiness"` |  |
| application.readinessProbe.periodSeconds | int | `2` |  |
| application.readinessProbe.port | int | `3000` |  |
| application.readinessProbe.timeoutSeconds | int | `5` |  |
| application.readinessProbe.type | string | `"http"` | Type of readiness healthcheck. `http` or `tcp` |
| authorizationPolicy.enabled | bool | `true` |  |
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
| cron.args | list | `[]` |  |
| cron.backoffLimit | int | `1` |  |
| cron.command | list | `[]` | Overrides the image entrypoint. Needed where the entrypoint starts the server, so a scheduled run has to invoke something else. |
| cron.concurrencyPolicy | string | `"Forbid"` |  |
| cron.enabled | bool | `false` |  |
| cron.failedJobsHistoryLimit | int | `3` |  |
| cron.name | string | `""` |  |
| cron.nodeSelector | object | `{}` | Node labels the cron pod must match. |
| cron.resources.limits.cpu | string | `nil` |  |
| cron.resources.limits.memory | string | `""` |  |
| cron.resources.requests.cpu | string | `nil` |  |
| cron.resources.requests.memory | string | `""` |  |
| cron.restartPolicy | string | `"Never"` |  |
| cron.schedule | string | `""` | Cron expression, evaluated in the cluster's timezone (UTC). |
| cron.successfulJobsHistoryLimit | int | `1` |  |
| cron.vault.enabled | bool | `true` |  |
| deployment.enabled | bool | `true` |  |
| deployment.hpa.enabled | bool | `true` |  |
| deployment.hpa.maxReplicas | int | `10` | Maximum number of replica pods |
| deployment.hpa.minReplicas | int | `3` | Minimum number of replica pods |
| deployment.hpa.targetCPU | int | `70` | Target CPU usage (%) |
| deployment.hpa.targetMemory | int | `70` | Target Memory usage (Mi). Default is `(request+limit) / 2`. Feel free to overwrite that here if necessary. |
| deployment.nodeSelector.labels | object | `{}` | Node labels the pod must match, merged with the toleration label above. `{eks.amazonaws.com/capacityType: ON_DEMAND}` keeps a pod off spot capacity on an EKS managed node group. |
| deployment.nodeSelector.toleration | string | `""` |  |
| deployment.replicaCount | int | `3` | Replica count not considering the HPA |
| deployment.strategy | object | `{}` | RollingUpdate parameters, e.g. `{maxSurge: 1, maxUnavailable: 0}` for zero-downtime rollouts. Omitted entirely when unset, which leaves the API server's 25% default — at 3 replicas that rounds to a surge of 1 and no unavailability, so the pods replace one at a time. |
| deployment.terminationGracePeriodSeconds | string | `""` | Seconds the kubelet waits between SIGTERM and SIGKILL. A spot interruption notice is 120 seconds, so a workload that must finish its current unit of work needs a value comfortably inside that. Omitted entirely when unset, which leaves Kubernetes' own default of 30. |
| deployment.topologySpreadConstraints | list | `[{"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"ScheduleAnyway"},{"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"}]` | Configure Topology Spread Constrains. A constraint carries a single topologyKey, so keeping replicas off one node and out of one availability zone are separate entries — list both. A bare mapping is still accepted for the single-constraint case. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints |
| destinationRule.enabled | bool | `true` |  |
| istio.externalIngress.enabled | bool | `true` |  |
| istio.externalIngress.path | string | `""` |  |
| istio.mtls.mode | string | `"STRICT"` |  |
| istio.principals | list | `[]` |  |
| istio.proxy.cpu | string | `""` |  |
| istio.proxy.cpuLimit | string | `""` |  |
| istio.proxy.memory | string | `""` |  |
| istio.proxy.memoryLimit | string | `""` |  |
| istio.subsets | list | `[]` |  |
| istio.tls.mode | string | `"ISTIO_MUTUAL"` |  |
| istio.virtualService.enabled | bool | `true` |  |
| istio.virtualService.gateways | list | `[]` |  |
| istio.virtualService.hosts | list | `[]` |  |
| job.annotations | string | `nil` |  |
| job.args | string | `""` |  |
| job.backoffLimit | int | `2` |  |
| job.enabled | bool | `false` |  |
| job.name | string | `""` |  |
| job.nodeSelector | object | `{"eks.amazonaws.com/capacityType":"ON_DEMAND"}` | Node labels the job pod must match. Defaults to on-demand capacity: a job that cannot be safely retried should not be interrupted, and it runs too briefly to be worth discounting. Set `nodeSelector: null` to lift it — an empty mapping will not, because Helm merges it into the default. |
| job.resources.limits.cpu | string | `nil` |  |
| job.resources.limits.memory | string | `""` |  |
| job.resources.requests.cpu | string | `nil` |  |
| job.resources.requests.memory | string | `""` |  |
| job.restartPolicy | string | `"OnFailure"` |  |
| job.ttlSecondsAfterFinished | int | `86400` | Seconds a finished job is kept before Kubernetes deletes it, long enough to read its logs after the fact. |
| job.vault.enabled | bool | `true` |  |
| pdb.enabled | bool | `false` |  |
| pdb.maxUnavailable | string | `""` | Pods that may be unavailable at once. Prefer this over `minAvailable` on an autoscaled service: `minAvailable: 1` against three replicas permits losing two, where `maxUnavailable: 1` bounds the loss whatever the replica count moves to. Mutually exclusive with `minAvailable`. |
| pdb.minAvailable | string | `""` | Pods that must stay available during a voluntary disruption. Defaults to 2 when neither this nor `maxUnavailable` is set. Mutually exclusive with it. |
| pdb.unhealthyPodEvictionPolicy | string | `"AlwaysAllow"` | Whether a pod that is running but not Ready may be evicted even when the budget is not met. `AlwaysAllow` stops a crash-looping pod from blocking a node drain; it is not serving traffic, so the budget has nothing to protect. |
| peerAuthentication.enabled | bool | `true` |  |
| service.enabled | bool | `true` |  |
| service.externalDNS.enabled | bool | `false` |  |
| service.externalDNS.host | string | `""` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.enabled | bool | `true` |  |
| serviceAccount.name | string | `""` | Leave blank to default to the application name |
| serviceEntry.enabled | bool | `false` |  |
| serviceEntry.hosts | list | `[]` |  |
| serviceEntry.location | string | `""` |  |
| serviceEntry.ports | list | `[]` |  |
| supervisor.cron.enabled | bool | `true` |  |
| supervisor.enabled | bool | `false` |  |
| supervisor.nodeSelector | object | `{}` | Node labels the supervisor pod must match. |
| supervisor.resources | object | `{}` | Resource requests/limits for the supervisor container. If unset, defaults to limits 500m/500Mi and requests 250m/250Mi. |
| supervisor.terminationGracePeriodSeconds | int | `110` | Seconds the kubelet waits between SIGTERM and SIGKILL. A ceiling, not a wait: the pod goes as soon as the process exits. A single-replica queue worker with the Kubernetes default of 30 loses whatever job is still running at that point, so this defaults to 110 — inside the 120 a spot interruption allows, and the same protection during an ordinary node drain. Also drives supervisord's `stopwaitsecs`, ten seconds lower, so the worker gets most of this window and supervisord still has time to exit before the kubelet's SIGKILL. Unset, supervisord falls back to its own 10s default, which is shorter than most jobs. |
| vault | object | `{"env":"","role":"","sharedEnv":""}` | Vault configuration |
| vault.env | string | `""` | Environment of the vault. Format: `<< env >>/<< vault name >> |
| vault.role | string | `""` | Role name |
| vault.sharedEnv | string | `""` | Optional path to a platform-wide shared secret (e.g. `<< env >>/data/_shared`). When set, its keys are appended into the same injected `/vault/secrets/env` file after the service's own secret, giving true single-source shared config. |
