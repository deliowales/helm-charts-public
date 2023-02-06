# php

A generic chart to be used for all PHP microservices

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square)

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
| application.cron | object | `{"enabled":false}` | Enable CRON. This is only to be used with `Horizon` |
| application.env | list | `[]` | Application environment variables. Currently, most of these should be stored in Vault and defined in Terragrunt. |
| application.extraVolumes | list | `[]` |  |
| application.healthcheck.headers | string | `""` |  |
| application.healthcheck.livenessPath | string | `"/_/system/liveness"` |  |
| application.healthcheck.readinessPath | string | `"/_/system/readiness"` |  |
| application.image.pullPolicy | string | `"Always"` |  |
| application.image.repository | string | `""` | Name of the ECR/ACR repository |
| application.image.tag | string | `"0.0.0"` | Image tag to be pulled |
| application.name | string | `"php"` | Name of the application e.g. Deals |
| application.ports.containerPort | int | `8080` |  |
| azure.identity.clientName | string | `""` |  |
| azure.identity.enabled | bool | `false` |  |
| azure.identity.name | string | `""` |  |
| azure.identity.resourceName | string | `""` |  |
| cloud.containerRegistryURL | string | `""` | **Required**: URL for the Container Registry |
| cloud.environment | string | `""` | **Required**: Cloud Environment. `staging-demo` (aws only), `demo`, `staging-production` (azure only) or `production`. |
| cloud.provider | string | `""` | **Required**: Cloud Provider. Either `AWS` or `Azure` |
| cloud.region | string | `""` | Cloud Region. Only needed for AWS |
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
| deployment.hpa.targetMemory | string | `""` | Target Memory usage (Mi). Default is `(request+limit) / 2`. Feel free to overwrite that here if necessary. |
| deployment.nginx.enabled | bool | `true` |  |
| deployment.nodeSelector.toleration | string | `""` |  |
| deployment.replicaCount | int | `3` | Replica count not considering the HPA |
| deployment.topologySpreadConstraints.maxSkew | int | `1` | Degree to which Pods may be unevenly distributed. |
| deployment.topologySpreadConstraints.topologyKey | string | `"topology.kubernetes.io/zone"` | Node label to spread on. |
| deployment.topologySpreadConstraints.whenUnsatisfiable | string | `"ScheduleAnyway"` | What to do if it doesn't satisfy the spread constraint. |
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
| phpConfig.maxExecutionTime | int | `30` |  |
| phpConfig.memoryLimit | string | `"128M"` |  |
| phpConfig.postMaxSize | string | `"8M"` |  |
| phpConfig.uploadMaxFilesize | string | `"2M"` |  |
| vault | object | `{"env":"","role":""}` | Vault configuration |
| vault.env | string | `""` | Environment of the vault. Format: `<< env >>/<< vault name >> |
| vault.role | string | `""` | Role name |
