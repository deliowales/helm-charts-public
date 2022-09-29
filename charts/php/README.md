# php

A generic chart to be used for all PHP microservices

![Version: 0.1.4](https://img.shields.io/badge/Version-0.1.4-informational?style=flat-square)

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
| application.healthcheck.livenessPath | string | `""` |  |
| application.healthcheck.readinessPath | string | `""` |  |
| application.image.pullPolicy | string | `"Always"` |  |
| application.image.repository | string | `""` | Name of the ECR/ACR repository |
| application.image.tag | string | `""` | Image tag to be pulled |
| application.name | string | `"php"` | Name of the application e.g. Deals |
| application.oldWorld.enabled | bool | `false` | Configure Old World deployments. Only to be used with `Horizon` or `Event`. |
| application.oldWorld.env | list | `[]` |  |
| application.oldWorld.image.pullPolicy | string | `"Always"` |  |
| application.oldWorld.image.repository | string | `""` |  |
| application.oldWorld.image.tag | string | `""` |  |
| authorizationPolicy.enabled | bool | `true` |  |
| aws | object | `{"iamRole":""}` | IAM Role to allow the application access to AWS resources (e.g. S3, SQS, Lambda) if needed. |
| azure.identity.clientName | string | `""` |  |
| azure.identity.enabled | bool | `false` |  |
| azure.identity.name | string | `""` |  |
| azure.identity.resourceName | string | `""` |  |
| cloud.containerRegistryURL | string | `""` | **Required**: URL for the Container Registry |
| cloud.environment | string | `""` | **Required**: Cloud Environment. `staging-demo` (aws only), `demo`, `staging-production` (azure only) or `production`. |
| cloud.provider | string | `""` | **Required**: Cloud Provider. Either `AWS` or `Azure` |
| cloud.region | string | `""` | Cloud Region. Only needed for AWS |
| deployment.enabled | bool | `true` |  |
| deployment.hpa.enabled | bool | `true` |  |
| deployment.hpa.maxReplicas | int | `10` | Maximum number of replica pods |
| deployment.hpa.minReplicas | int | `3` | Minimum number of replica pods |
| deployment.hpa.targetCPU | int | `70` | Target CPU usage (%) |
| deployment.hpa.targetMemory | string | `""` | Target Memory usage (Mi). Default is `(request+limit) / 2`. Feel free to overwrite that here if necessary. |
| deployment.replicaCount | int | `3` | Replica count not considering the HPA |
| deployment.topologySpreadConstraints | object | `{"enabled":false,"maxSkew":null,"topologyKey":null,"whenUnsatisfiable":null}` | Configure Topology Spread Constrains. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints |
| destinationRule.enabled | bool | `true` |  |
| ingress.enabled | bool | `false` |  |
| ingress.path | string | `""` |  |
| ingress.pathRouted | string | `""` |  |
| istio.mtls.mode | string | `"STRICT"` |  |
| istio.portLevelSettings | list | `[]` |  |
| istio.principals | list | `[]` |  |
| istio.subsets | list | `[]` |  |
| istio.tls.mode | string | `"ISTIO_MUTUAL"` |  |
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
| kong.enabled | bool | `false` |  |
| newrelic | object | `{"licenseKey":""}` | The license key for New Relic. Only needed for FluentBit containers which are only used by PHP services. |
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
| phpConfig.maxExecutionTime | string | `""` |  |
| phpConfig.memoryLimit | string | `""` |  |
| phpConfig.postMaxSize | string | `""` |  |
| phpConfig.uploadMaxFilesize | string | `""` |  |
| service.enabled | bool | `true` |  |
| service.externalDNS.enabled | bool | `false` |  |
| service.externalDNS.host | string | `""` |  |
| service.kong | object | `{"stripPath":""}` | Strip the path defined in Ingress resource and then forward the request to the upstream service. |
| service.port | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.enabled | bool | `true` |  |
| serviceAccount.name | string | `""` | Leave blank to default to the application name |
| serviceEntry.enabled | bool | `false` |  |
| serviceEntry.hosts | list | `[]` |  |
| serviceEntry.location | string | `""` |  |
| serviceEntry.ports | list | `[]` |  |
| supervisor | object | `{"enabled":false}` | Only needed for Analytics Old-world |
| vault | object | `{"env":"","role":""}` | Vault configuration |
| vault.env | string | `""` | Environment of the vault. Format: `<< env >>/<< vault name >> |
| vault.role | string | `""` | Role name |
| virtualService.enabled | bool | `true` |  |
| virtualService.gateways | list | `[]` |  |
| virtualService.hosts | list | `[]` |  |