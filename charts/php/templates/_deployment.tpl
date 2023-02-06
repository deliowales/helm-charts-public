{{- define "php.deployment.tsc" -}}
  topologySpreadConstraints:
  - maxSkew: {{ .Values.deployment.tsc.maxSkew }}
    topologyKey: {{ .Values.deployment.tsc.topologyKey }}
    whenUnsatisfiable: {{ .Values.deployment.tsc.whenUnsatisfiable }}
    labelSelector:
      matchLabels:
        app: {{ .Values.application.name | lower }}
{{- end }}

{{/*
Set the targetMemory to be (request+limit) / 2. Automatically rounded down to nearest integer.
*/}}
{{- define "php.deployment.hpa.targetMemory" -}}
  {{- div (add (.Values.application.resources.requests.memory | trimAll "Mi") (.Values.application.resources.limits.memory | trimAll "Mi")) 2 -}}Mi
{{- end -}}

{{- define "php.deployment.nginx.imageURL" -}}
  {{- printf "%s/%s:%s" .Values.cloud.containerRegistryURL .Values.nginx.image.repository .Values.nginx.image.tag }}
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
