{{/* vim: set filetype=mustache: */}}

{{/*
Global labels. Do not indent, this is done in the manifest.
*/}}
{{- define "microservice.labels" -}}
{{ printf "app.kubernetes.io/name: %s" .Values.application.name | lower }}
{{ printf "chart: %s-%s" .Chart.Name (.Chart.Version | replace "+" "_") }}
{{ printf "release-name: %s" .Release.Name }}
{{- end -}}

{{/*
Global annotations. Do not indent, this is done in the manifest.
*/}}
{{- define "microservice.annotations" -}}
{{ printf "app.kubernetes.io/managed-by: %s" .Release.Service }}
{{ printf "release-timestamp: %s" (now | date "2006-01-02 15:04:05" | quote) }}
{{ printf "release-revision: %s" (.Release.Revision | quote) }}
{{- end -}}

{{/*
Application Name
*/}}
{{- define "microservice.application.name" -}}
  {{ .Values.application.name | required "Required: Application Language << .Values.application.name >>" | lower }}
{{- end -}}

{{/*
Container Port
*/}}
{{- define "microservice.application.language" -}}
  {{- .Values.application.language | required "Required: Application Language << .Values.application.language >>" | lower }}
{{- end -}}

{{/*
Container Port
*/}}
{{- define "microservice.application.containerPort" -}}
  {{- if eq (include "microservice.application.language" . ) "php" }}
    {{- default "8080" .Values.application.containerPort }}
  {{- else if eq (include "microservice.application.language" . ) "node" }}
    {{- default "3000" .Values.application.containerPort }}
  {{- else }}
    {{ .Values.application.containerPort }}
  {{- end }}
{{- end -}}

{{/*
Application Name
*/}}
{{- define "microservice.cloud.environment" -}}
  {{ .Values.cloud.environment | lower | required "Required: Application Name << .Values.cloud.environment >>" }}
{{- end -}}

{{- define "microservice.cloud.provider" -}}
  {{ .Values.cloud.provider | lower | required "Required: Cloud Provider << .Values.cloud.provider >>" }}
{{- end -}}

{{/*
Container Registry URL
*/}}
{{- define "microservice.cloud.containerRegistryURL" -}}
  {{ .Values.cloud.containerRegistryURL | required "Required: Cloud Container Registry URL << .Values.cloud.containerRegistryURL >>" }}
{{- end -}}

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
Define the container image urls
*/}}
{{- define "microservice.project.imageURL" -}}
  {{- printf "%s/%s:%s" (include "microservice.cloud.containerRegistryURL" .) .Values.application.image.repository (include "microservice.application.image.tag" . | required "An image tag needs to be defined.") }}
{{- end -}}

{{- define "microservice.project.oldWorldImageURL" -}}
  {{- printf "%s/%s:%s" (include "microservice.cloud.containerRegistryURL" .) .Values.application.oldWorld.image.repository (include "microservice.application.image.tag" . | required "An image tag needs to be defined.") }}
{{- end -}}

{{- define "microservice.nginx.imageURL" -}}
  {{- printf "%s/%s:%s" .Values.cloud.containerRegistryURL .Values.nginx.image.repository .Values.nginx.image.tag }}
{{- end -}}

{{- define "microservice.logging.imageURL" -}}
  {{- printf "%s/%s:%s" .Values.cloud.containerRegistryURL .Values.logging.image.repository .Values.logging.image.tag }}
{{- end -}}

{{/*
Set the targetMemory to be (request+limit) / 2. Automatically rounded down to nearest integer.
*/}}
{{- define "microservice.hpa.targetMemory" -}}
  {{- div (add (.Values.application.resources.requests.memory | trimAll "Mi") (.Values.application.resources.limits.memory | trimAll "Mi")) 2 -}}Mi
{{- end -}}


{{/*
Vault Agent Annotations
*/}}
{{- define "microservice.vault.annotations" -}}
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