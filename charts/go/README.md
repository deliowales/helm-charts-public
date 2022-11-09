# go

A generic chart to be used for all GoLang microservices

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

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
| application.image.pullPolicy | string | `"Always"` |  |
| application.image.repository | string | `""` | Name of the ECR/ACR repository |
| application.image.tag | string | `""` | Image tag to be pulled |
| application.livenessProbe.httpHeaders | list | `[]` | Custom headers to set in the request. HTTP allows repeated headers. |
| application.livenessProbe.path | string | `"/_/system/liveness"` |  |
| application.livenessProbe.type | string | `"http"` | Type of liveness healthcheck. `http` or `tcp` |
| application.name | string | `"go"` | Name of the application e.g. Deals |
| application.readinessProbe.httpHeaders | list | `[]` | Custom headers to set in the request. HTTP allows repeated headers. |
| application.readinessProbe.path | string | `"/_/system/readiness"` |  |
| application.readinessProbe.type | string | `"http"` | Type of readiness healthcheck. `http` or `tcp` |
| authorizationPolicy.enabled | bool | `true` |  |
| aws | object | `{"iamRole":""}` | IAM Role to allow the application access to AWS resources (e.g. S3, SQS, Lambda) if needed. |
| azure.identity.clientName | string | `""` |  |
| azure.identity.enabled | bool | `false` |  |
| azure.identity.name | string | `""` |  |
| azure.identity.resourceName | string | `""` |  |
| clamAV | object | `{"enabled":false}` | Enable ClamAV. Currently only used by `virus-scanner`. |
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
| pdb.enabled | bool | `false` |  |
| pdb.minAvailable | int | `2` |  |
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
| vault | object | `{"env":"","role":""}` | Vault configuration |
| vault.env | string | `""` | Environment of the vault. Format: `<< env >>/<< vault name >> |
| vault.role | string | `""` | Role name |
| virtualService.enabled | bool | `true` |  |
| virtualService.gateways | list | `[]` |  |
| virtualService.hosts | list | `[]` |  |
