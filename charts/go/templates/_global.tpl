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

{{/*
Sidecar resources for one pod. Istio reads these annotations *instead of* the
mesh defaults, not merged with them, so a partial set would silently drop the
request and both limits — all four are emitted together or none are. istio-init
resolves from the same annotations and cannot be given its own values.
*/}}
{{- define "go.istio.proxy.annotations" -}}
{{- $proxy := .Values.istio.proxy | default dict -}}
{{- if or $proxy.cpu $proxy.memory $proxy.cpuLimit $proxy.memoryLimit }}
sidecar.istio.io/proxyCPU: {{ $proxy.cpu | default "30m" | quote }}
sidecar.istio.io/proxyMemory: {{ $proxy.memory | default "128Mi" | quote }}
sidecar.istio.io/proxyCPULimit: {{ $proxy.cpuLimit | default "2000m" | quote }}
sidecar.istio.io/proxyMemoryLimit: {{ $proxy.memoryLimit | default "1024Mi" | quote }}
{{- end }}
{{- end -}}
