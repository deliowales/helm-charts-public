{{/*
Application Name
*/}}
{{- define "php.cloud.environment" -}}
  {{ .Values.cloud.environment | lower | required "Required: Application Name << .Values.cloud.environment >>" }}
{{- end -}}

{{- define "php.cloud.provider" -}}
  {{ .Values.cloud.provider | lower | required "Required: Cloud Provider << .Values.cloud.provider >>" }}
{{- end -}}

{{/*
Container Registry URL
*/}}
{{- define "php.cloud.containerRegistryURL" -}}
  {{ .Values.cloud.containerRegistryURL | required "Required: Cloud Container Registry URL << .Values.cloud.containerRegistryURL >>" }}
{{- end -}}
