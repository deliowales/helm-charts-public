{{/* Create chart name and version as used by the chart label. */}}
{{- define "go.chartref" -}}
{{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end }}

{{/*
Global labels. Do not indent, this is done in the manifest.
*/}}
{{- define "go.labels" -}}
app.kubernetes.io/name: {{ .Values.application.name | lower }}
chart: {{ include "go.chartref" . }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Global annotations. Do not indent, this is done in the manifest.
*/}}
{{- define "go.annotations" -}}
{{ printf "app.kubernetes.io/managed-by: %s" .Release.Service }}
{{ printf "release-timestamp: %s" (now | date "2006-01-02 15:04:05" | quote) }}
{{ printf "release-revision: %s" (.Release.Revision | quote) }}
{{- end -}}
