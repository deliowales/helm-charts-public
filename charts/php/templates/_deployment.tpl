{{- define "php.deployment.topologySpreadConstraints" -}}
  topologySpreadConstraints:
  - maxSkew: {{ .Values.deployment.topologySpreadConstraints.maxSkew }}
    topologyKey: {{ .Values.deployment.topologySpreadConstraints.topologyKey }}
    whenUnsatisfiable: {{ .Values.deployment.topologySpreadConstraints.whenUnsatisfiable }}
    labelSelector:
      matchLabels:
        app: {{ .Values.application.name | lower }}
{{- end }}

{{- define "php.deployment.nginx.imageURL" -}}
  {{- printf "%s/%s:%s" .Values.cloud.containerRegistryURL .Values.nginx.image.repository .Values.nginx.image.tag }}
{{- end -}}

{{- define "php.deployment.nightwatch.imageURL" -}}
  {{- if contains "/" .Values.nightwatch.image.repository -}}
    {{- printf "%s:%s" .Values.nightwatch.image.repository .Values.nightwatch.image.tag }}
  {{- else -}}
    {{- printf "%s/%s:%s" .Values.cloud.containerRegistryURL .Values.nightwatch.image.repository .Values.nightwatch.image.tag }}
  {{- end -}}
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
