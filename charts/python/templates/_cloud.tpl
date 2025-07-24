{{/*
Application Name
*/}}
{{- define "python.cloud.environment" -}}
  {{ .Values.cloud.environment | lower | required "Required: Application Name << .Values.cloud.environment >>" }}
{{- end -}}

{{- define "python.cloud.provider" -}}
  {{ .Values.cloud.provider | required "Required: Cloud Provider << .Values.cloud.provider >>" }}
{{- end -}}

{{/*
Container Registry URL
*/}}
{{- define "python.cloud.containerRegistryURL" -}}
  {{ .Values.cloud.containerRegistryURL | required "Required: Cloud Container Registry URL << .Values.cloud.containerRegistryURL >>" }}
{{- end -}}
