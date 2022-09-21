{{/*
Application Name
*/}}
{{- define "microservice.application.name" -}}
  {{ .Values.application.name | required "Required: Application Language << .Values.application.name >>" | lower }}
{{- end -}}

{{/*
Define the container image urls
*/}}
{{- define "microservice.application.imageURL" -}}
  {{- printf "%s/%s:%s" (include "microservice.cloud.containerRegistryURL" .) .Values.application.image.repository (include "microservice.application.image.tag" . | required "An image tag needs to be defined.") }}
{{- end -}}

{{- define "microservice.application.oldWorldImageURL" -}}
  {{- printf "%s/%s:%s" (include "microservice.cloud.containerRegistryURL" .) .Values.application.oldWorld.image.repository (include "microservice.application.image.tag" . | required "An image tag needs to be defined.") }}
{{- end -}}

{{/*
Define container security context
*/}}
{{- define "microservice.application.securityContext" -}}
  securityContext:
  runAsUser: 1000
  runAsGroup: 1000
  runAsNonRoot: true
  readOnlyRootFilesystem: true
{{- end }}

{{/*
Define container image tag
*/}}
{{- define "microservice.application.image.tag" -}}
  {{- $provider := (include "microservice.cloud.provider" .) -}}
  {{- $environment := (include "microservice.cloud.environment" .) -}}
  {{- if or (and (or (eq $environment "uat") (eq $environment "staging-demo")) (eq $provider "aws")) (and (eq $environment "staging-production") (eq $provider "azure")) -}}
    {{- default "latest" .Values.application.image.tag -}}
  {{- end -}}
{{- end -}}

{{/*
Vault Agent Annotations
*/}}
{{- define "microservice.application.vault.annotations" -}}
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-pre-populate: "true"
vault.hashicorp.com/agent-pre-populate-only: "true"
vault.hashicorp.com/agent-init-first: "true"
vault.hashicorp.com/role: {{ .Values.vault.role }}
vault.hashicorp.com/agent-inject-secret-env: {{ .Values.vault.env }}
vault.hashicorp.com/agent-inject-template-env: |
  {{ `{{ with secret "` }}{{ .Values.vault.env }}{{`"  -}}
  {{ range $k, $v := .Data.data -}}
  export {{ $k }}='{{ $v }}'
  {{ end -}}
  {{ end -}}` }}
{{- end -}}
