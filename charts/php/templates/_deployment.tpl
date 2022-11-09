{{- define "php.deployment.topologySpreadConstraints" -}}
  topologySpreadConstraints:
  - maxSkew: {{ .Values.deployment.topologySpreadConstraints.maxSkew | default "1" }}
    topologyKey: {{ .Values.deployment.topologySpreadConstraints.topologyKey | default "topology.kubernetes.io/zone" }}
    whenUnsatisfiable: {{ .Values.deployment.topologySpreadConstraints.whenUnsatisfiable | default "ScheduleAnyway" }}
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
