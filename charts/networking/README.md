# networking

A networking chart to be used for all microservices

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
| authorizationPolicy.enabled | bool | `true` |  |
| aws.iamRolePrefix | string | `""` |  |
| destinationRule.enabled | bool | `true` |  |
| istio.externalIngress.enabled | bool | `true` |  |
| istio.externalIngress.path | string | `""` |  |
| istio.mtls.mode | string | `"STRICT"` |  |
| istio.portLevelSettings | list | `[]` |  |
| istio.principals | list | `[]` |  |
| istio.subsets | list | `[]` |  |
| istio.timeout | string | `"2s"` |  |
| istio.tls.mode | string | `"ISTIO_MUTUAL"` |  |
| istio.virtualService.enabled | bool | `true` |  |
| istio.virtualService.gateways | list | `[]` |  |
| istio.virtualService.hosts | list | `[]` |  |
| istio.virtualService.rules | list | `[]` |  |
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
