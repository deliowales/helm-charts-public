{{/*
Application Name
*/}}
{{- define "rust.cloud.environment" -}}
  {{ .Values.cloud.environment | lower | required "Required: Application Name << .Values.cloud.environment >>" }}
{{- end -}}

{{- define "rust.cloud.provider" -}}
  {{ .Values.cloud.provider | required "Required: Cloud Provider << .Values.cloud.provider >>" }}
{{- end -}}

{{/*
Container Registry URL
*/}}
{{- define "rust.cloud.containerRegistryURL" -}}
  {{ .Values.cloud.containerRegistryURL | required "Required: Cloud Container Registry URL << .Values.cloud.containerRegistryURL >>" }}
{{- end -}}
