{{/*
Application Name
*/}}
{{- define "go.cloud.environment" -}}
  {{ .Values.cloud.environment | lower | required "Required: Application Name << .Values.cloud.environment >>" }}
{{- end -}}

{{- define "go.cloud.provider" -}}
  {{ .Values.cloud.provider | required "Required: Cloud Provider << .Values.cloud.provider >>" }}
{{- end -}}

{{/*
Container Registry URL
*/}}
{{- define "go.cloud.containerRegistryURL" -}}
  {{ .Values.cloud.containerRegistryURL | required "Required: Cloud Container Registry URL << .Values.cloud.containerRegistryURL >>" }}
{{- end -}}
