{{- define "go.deployment.topologySpreadConstraints" -}}
  topologySpreadConstraints:
  - maxSkew: {{ .Values.deployment.topologySpreadConstraints.maxSkew }}
    topologyKey: {{ .Values.deployment.topologySpreadConstraints.topologyKey }}
    whenUnsatisfiable: {{ .Values.deployment.topologySpreadConstraints.whenUnsatisfiable }}
    labelSelector:
      matchLabels:
        app: {{ .Values.application.name | lower }}
{{- end }}

{{/*
Set the targetMemory to be (request+limit) / 2. Automatically rounded down to nearest integer.
*/}}
{{- define "go.deployment.hpa.targetMemory" -}}
  {{- if and (hasSuffix "Mi" .Values.application.resources.requests.memory) (hasSuffix "Mi" .Values.application.resources.limits.memory)  -}}
  {{ div (add (.Values.application.resources.requests.memory | trimAll "Mi") (.Values.application.resources.limits.memory | trimAll "Mi")) 2 }}Mi
  {{- else if and (hasSuffix "Gi" .Values.application.resources.requests.memory) (hasSuffix "Gi" .Values.application.resources.limits.memory)  -}}
  {{ divf (add (.Values.application.resources.requests.memory | trimAll "Gi") (.Values.application.resources.limits.memory | trimAll "Gi")) 2 }}Gi
  {{- else -}}
  {{ fail "Memory units must be in either Mi or Gi" }}
  {{- end }}
{{- end -}}

{{/*
Set the nodeSelector toleration
*/}}
{{- define "node.deployment.nodeSelector.toleration" -}}
  {{- if eq .Values.deployment.nodeSelector.toleration "cpu" -}}
    scheduling.cast.ai/compute-optimized: "true"
  {{- else -}}
    scheduling.cast.ai/memory-optimized: "true"
  {{- end }}
{{- end -}}
