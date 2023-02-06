# networking

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square)

A networking chart to be used for all microservices

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| authorizationPolicy.enabled | bool | `true` |  |
| aws.iamRole | string | `""` |  |
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
