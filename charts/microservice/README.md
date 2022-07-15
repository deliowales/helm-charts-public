# microservice

A generic chart to be used for all microervices

![Version: 0.0.14](https://img.shields.io/badge/Version-0.0.14-informational?style=flat-square)

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
| application.containerPort | string | `""` | Port that the container is running on. The default port depends on the programming language |
| application.cron | object | `{"enabled":false}` | Enable CRON. This is only to be used with `Horizon` |
| application.env | list | `[]` | Application environment variables. Currently, most of these should be stored in Vault and defined in Terragrunt. |
| application.image | object | `{"pullPolicy":"Always","repository":null,"tag":""}` | Configure container registry details |
| application.image.repository | string | `nil` | Name of the ECR/ACR repository |
| application.image.tag | string | `""` | Image tag to be pulled |
| application.language | string | `nil` | Application programming language used; `php`, `node` or `go` |
| application.livenessProbe | object | `{"httpHeaders":[],"path":"/_/system/liveness","type":"http"}` | Configure the liveness healthcheck for the application container |
| application.livenessProbe.httpHeaders | list | `[]` | Custom headers to set in the request. HTTP allows repeated headers. |
| application.livenessProbe.type | string | `"http"` | Type of healthcheck. `http` or `tcp` |
| application.name | string | `""` | Name of the application e.g. Deals |
| application.oldWorld | object | `{"enabled":false,"env":[],"image":{"pullPolicy":"Always","repository":null,"tag":""}}` | Configure Old World deployments. Only to be used with `Horizon` or `Event`. |
| application.readinessProbe | object | `{"httpHeaders":[],"path":"/_/system/readiness","type":"http"}` | Configure the readiness healthcheck for the application container |
| application.readinessProbe.httpHeaders | list | `[]` | Custom headers to set in the request. HTTP allows repeated headers. |
| application.readinessProbe.type | string | `"http"` | Type of healthcheck. `http` or `tcp` |
| application.resources | object | `{"limits":{"cpu":null,"memory":""},"requests":{"cpu":"","memory":""}}` | Application container resources. Please ensure that these are fine-tuned when load-testing has been carried out and a baseline has been defined. |
| authorizationPolicy.enabled | bool | `true` |  |
| aws | object | `{"iamRole":""}` | IAM Role to allow the application access to AWS resources (e.g. S3, SQS, Lambda) if needed. |
| azure.identity.clientName | string | `""` |  |
| azure.identity.enabled | bool | `false` |  |
| azure.identity.name | string | `""` |  |
| azure.identity.resourceName | string | `""` |  |
| clamAV | object | `{"enabled":false}` | Enable ClamAV. Currently only used by `virus-scanner`. |
| cloud | object | `{"containerRegistryURL":"","environment":"","provider":"","region":""}` | Configure cloud details |
| cloud.containerRegistryURL | string | `""` | **Required**: URL for the Container Registry |
| cloud.environment | string | `""` | **Required**: Cloud Environment. `staging-demo` (aws only), `demo`, `staging-production` (azure only) or `production`. |
| cloud.provider | string | `""` | **Required**: Cloud Provider. Either `AWS` or `Azure` |
| cloud.region | string | `""` | Cloud Region. Only needed for AWS |
| deployment.enabled | bool | `true` |  |
| deployment.hpa | object | `{"enabled":true,"maxReplicas":10,"minReplicas":3,"targetCPU":70,"targetMemory":""}` | Horizontal Pod Autoscaler configuration. |
| deployment.hpa.maxReplicas | int | `10` | Maximum number of replica pods |
| deployment.hpa.minReplicas | int | `3` | Minimum number of replica pods |
| deployment.hpa.targetCPU | int | `70` | Target CPU usage (%) |
| deployment.hpa.targetMemory | string | `""` | Target Memory usage (Mi). Default is `(request+limit) / 2`. Feel free to overwrite that here if necessary. |
| deployment.replicaCount | int | `3` | Replica count not considering the HPA |
| deployment.topologySpreadConstraints | list | `[]` | Configure Topology Spread Constrains. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints |
| destinationRule.enabled | bool | `true` |  |
| ingress.enabled | bool | `false` |  |
| ingress.path | string | `""` |  |
| ingress.pathRouted | string | `""` |  |
| istio.mtls.mode | string | `"STRICT"` |  |
| istio.principals | list | `[]` |  |
| istio.subsets | list | `[]` |  |
| istio.tls.mode | string | `"ISTIO_MUTUAL"` |  |
| kongIngress.enabled | bool | `false` |  |
| logging | object | `{"image":{"pullPolicy":"Always","repository":"fluent-bit","tag":"1.9.1"},"logPath":"/var/www/html/storage/logs/lumen.log","multiLine":"On","parserPath":"/fluent-bit/etc/php-parser.conf","resources":{"limits":{"cpu":"100m","memory":"100Mi"},"requests":{"cpu":"10m","memory":"10Mi"}}}` | Configure FluentBit - PHP services only |
| logging.logPath | string | `"/var/www/html/storage/logs/lumen.log"` | Path to application log. If framework is `laravel`, you must use `laravel.log` instead of `lumen.log` |
| newrelic | object | `{"licenseKey":""}` | The license key for New Relic. Only needed for FluentBit containers which are only used by PHP services. |
| nginx.enabled | bool | `true` |  |
| nginx.image.pullPolicy | string | `"Always"` |  |
| nginx.image.repository | string | `"nginx"` |  |
| nginx.image.tag | string | `"1.21.1-alpine-unprivileged"` |  |
| nginx.resources.limits.cpu | string | `"100m"` |  |
| nginx.resources.limits.memory | string | `"128Mi"` |  |
| nginx.resources.requests.cpu | string | `"10m"` |  |
| nginx.resources.requests.memory | string | `"10Mi"` |  |
| nginx.service.internalPort | string | `""` | Port that nginx is listening on |
| nginx.service.type | string | `"NodePort"` |  |
| pdb | object | `{"enabled":false,"minAvailable":2}` | Pod Disruption Budget. Leave as false unless instructed otherwise. |
| peerAuthentication.enabled | bool | `true` |  |
| phpConfig | object | `{"maxExecutionTime":"","memoryLimit":"","postMaxSize":"","uploadMaxFilesize":""}` | Configuration options for `php.ini`. Leave blank for default values. |
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
| serviceEntry.location | string | `nil` |  |
| serviceEntry.ports | list | `[]` |  |
| supervisor | object | `{"enabled":false}` | Only needed for Analytics Old-world |
| vault | object | `{"env":"","role":""}` | Vault configuration |
| vault.env | string | `""` | Environment of the vault. Format: `<< env >>/<< vault name >> |
| vault.role | string | `""` | Role name |
| virtualService.enabled | bool | `true` |  |
| virtualService.gateways | list | `[]` |  |
| virtualService.hosts | list | `[]` |  |