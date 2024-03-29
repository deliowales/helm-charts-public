# php

A generic chart to be used for all PHP microservices

![Version: 1.2.17](https://img.shields.io/badge/Version-1.2.17-informational?style=flat-square)

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
| application.cron | object | `{"enabled":false,"phpConfig":{"maxExecutionTime":30}}` | Enable CRON. This is only to be used with `Horizon` |
| application.env | list | `[]` | Application environment variables. Currently, most of these should be stored in Vault and defined in Terragrunt. |
| application.extraVolumes | list | `[]` |  |
| application.healthcheck.headers | string | `""` |  |
| application.healthcheck.livenessPath | string | `"/_/system/liveness"` |  |
| application.healthcheck.readinessPath | string | `"/_/system/readiness"` |  |
| application.image.pullPolicy | string | `"Always"` |  |
| application.image.repository | string | `""` | Name of the ECR/ACR repository |
| application.image.tag | string | `"0.0.0"` | Image tag to be pulled |
| application.livenessProbe.enabled | bool | `true` |  |
| application.migrations.args | string | `"migrations"` |  |
| application.migrations.backoffLimit | int | `2` |  |
| application.migrations.enabled | bool | `false` |  |
| application.migrations.resources.limits.cpu | int | `1` |  |
| application.migrations.resources.limits.memory | string | `"1G"` |  |
| application.migrations.resources.requests.cpu | string | `"500m"` |  |
| application.migrations.resources.requests.memory | string | `"500M"` |  |
| application.migrations.restartPolicy | string | `"OnFailure"` |  |
| application.name | string | `"php"` | Name of the application e.g. Deals |
| application.readinessProbe.enabled | bool | `true` |  |
| authorizationPolicy.enabled | bool | `true` |  |
| aws | object | `{"iam":{"enabled":false,"role":"","rolePrefix":""}}` | IAM Role to allow the application access to AWS resources (e.g. S3, SQS, Lambda) if needed. |
| azure.identity.clientName | string | `""` |  |
| azure.identity.enabled | bool | `false` |  |
| azure.identity.name | string | `""` |  |
| azure.identity.resourceName | string | `""` |  |
| cloud.containerRegistryURL | string | `"1234.ecr.com"` | **Required**: URL for the Container Registry |
| cloud.environment | string | `"uat"` | **Required**: Cloud Environment. `staging-demo` (aws only), `demo`, `staging-production` (azure only) or `production`. |
| cloud.provider | string | `"aws"` | **Required**: Cloud Provider. Either `AWS` or `Azure` |
| cloud.region | string | `"eu-west-1"` | Cloud Region. Only needed for AWS |
| cron.args | string | `""` |  |
| cron.backoffLimit | int | `1` |  |
| cron.concurrencyPolicy | string | `"Forbid"` |  |
| cron.enabled | bool | `false` |  |
| cron.failedJobsHistoryLimit | int | `3` |  |
| cron.resources.limits.cpu | string | `nil` |  |
| cron.resources.limits.memory | string | `""` |  |
| cron.resources.requests.cpu | string | `nil` |  |
| cron.resources.requests.memory | string | `""` |  |
| cron.restartPolicy | string | `"OnFailure"` |  |
| cron.schedule | string | `""` |  |
| cron.successfulJobsHistoryLimit | int | `1` |  |
| cron.vault.enabled | bool | `true` |  |
| deployment.enabled | bool | `true` |  |
| deployment.hpa.enabled | bool | `true` |  |
| deployment.hpa.maxReplicas | int | `10` | Maximum number of replica pods |
| deployment.hpa.minReplicas | int | `3` | Minimum number of replica pods |
| deployment.hpa.targetCPU | int | `70` | Target CPU usage (%) |
| deployment.hpa.targetMemory | int | `70` | Target Memory usage (Mi). Default is `(request+limit) / 2`. Feel free to overwrite that here if necessary. |
| deployment.nginx.enabled | bool | `true` |  |
| deployment.nodeSelector.toleration | string | `""` |  |
| deployment.replicaCount | int | `3` | Replica count not considering the HPA |
| deployment.topologySpreadConstraints | object | `{"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"}` | Configure Topology Spread Constrains. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints |
| destinationRule.enabled | bool | `true` |  |
| istio.externalIngress.enabled | bool | `true` |  |
| istio.externalIngress.path | string | `""` |  |
| istio.mtls.mode | string | `"STRICT"` |  |
| istio.portLevelSettings | list | `[]` |  |
| istio.principals | list | `[]` |  |
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
| job.resources.limits.cpu | string | `nil` |  |
| job.resources.limits.memory | string | `""` |  |
| job.resources.requests.cpu | string | `nil` |  |
| job.resources.requests.memory | string | `""` |  |
| job.restartPolicy | string | `"OnFailure"` |  |
| job.vault.enabled | bool | `true` |  |
| newrelic | object | `{"licenseKey":""}` | The license key for New Relic. Only needed for FluentBit containers which are only used by PHP services. |
| nginx.config.clientMaxBodySize | string | `"1M"` |  |
| nginx.image.pullPolicy | string | `"Always"` |  |
| nginx.image.repository | string | `"nginx"` |  |
| nginx.image.tag | string | `"1.21.1-alpine-unprivileged"` |  |
| nginx.resources.limits.cpu | string | `"100m"` |  |
| nginx.resources.limits.memory | string | `"128Mi"` |  |
| nginx.resources.requests.cpu | string | `"10m"` |  |
| nginx.resources.requests.memory | string | `"10Mi"` |  |
| nginx.service.internalPort | string | `""` | Port that nginx is listening on |
| nginx.service.type | string | `"NodePort"` |  |
| pdb.enabled | bool | `false` |  |
| pdb.minAvailable | int | `2` |  |
| peerAuthentication.enabled | bool | `true` |  |
| phpConfig.maxExecutionTime | int | `30` |  |
| phpConfig.memoryLimit | string | `"128M"` |  |
| phpConfig.postMaxSize | string | `"8M"` |  |
| phpConfig.sessionHandler | string | `""` |  |
| phpConfig.sessionSavePath | string | `""` |  |
| phpConfig.uploadMaxFilesize | string | `"2M"` |  |
| scheduler.enabled | bool | `false` |  |
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
| serviceEntry.ping.hosts | list | `[]` |  |
| serviceEntry.ports | list | `[]` |  |
| supervisor.enabled | bool | `true` |  |
| supervisor.horizon.enabled | bool | `false` |  |
| supervisor.hpa.enabled | bool | `false` |  |
| supervisor.resources.limits.cpu | string | `"500m"` |  |
| supervisor.resources.limits.memory | string | `"500Mi"` |  |
| supervisor.resources.requests.cpu | string | `"250m"` |  |
| supervisor.resources.requests.memory | string | `"250Mi"` |  |
| vault | object | `{"env":"","role":""}` | Vault configuration |
| vault.env | string | `""` | Environment of the vault. Format: `<< env >>/<< vault name >> |
| vault.role | string | `""` | Role name |
