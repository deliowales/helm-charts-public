{{- define "node.deployment.topologySpreadConstraints" -}}
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
{{- define "node.deployment.hpa.targetMemory" -}}
  {{- div (add (.Values.application.resources.requests.memory | trimAll "Mi") (.Values.application.resources.limits.memory | trimAll "Mi")) 2 -}}Mi
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
