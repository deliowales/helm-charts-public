{{/*Application Name*/}}

{{- define "networking.application.name" -}}
  {{ .Values.global.application.name | required "Required: Application Name << .Values.application.name >>" | lower -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "networking.chartref" -}}
    {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end }}

{{/*Global labels. Do not indent, this is done in the manifest.*/}}
{{- define "networking.labels" }}
{{- printf "app.kubernetes.io/name: %s" (include "networking.application.name" .) }}
{{ printf "chart: %s" (include "networking.chartref" .) }}
{{ printf "release: %s" (.Release.Name | quote) }}
{{- end -}}

{{/*Global annotations. Do not indent, this is done in the manifest.*/}}
{{- define "networking.annotations" -}}
{{- printf "app.kubernetes.io/managed-by: %s" .Release.Service }}
{{ printf "release-timestamp: %s" (now | date "2006-01-02 15:04:05" | quote) }}
{{ printf "release-revision: %s" (.Release.Revision | quote) }}
{{- end -}}
