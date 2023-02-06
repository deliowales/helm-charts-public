{{/*
Application Name
*/}}
{{- define "node.application.name" -}}
  {{ .Values.global.application.name | required "Required: Application Name << .Values.global.application.name >>" | lower }}
{{- end -}}

{{/*
Define the container image urls
*/}}
{{- define "node.application.imageURL" -}}
  {{- printf "%s/%s:%s" (include "node.cloud.containerRegistryURL" .) .Values.application.image.repository (.Values.application.image.tag | required "An image tag needs to be defined.") }}
{{- end -}}

{{/*
Define container security context
*/}}
{{- define "node.application.securityContext" -}}
  securityContext:
  runAsUser: 1000
  runAsGroup: 1000
  runAsNonRoot: true
  readOnlyRootFilesystem: true
{{- end }}

{{/*
Vault Agent Annotations
*/}}
{{- define "node.application.vault.annotations" -}}
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-pre-populate: "true"
vault.hashicorp.com/agent-pre-populate-only: "true"
vault.hashicorp.com/agent-init-first: "true"
vault.hashicorp.com/role: {{ .Values.vault.role }}
vault.hashicorp.com/agent-inject-secret-env: {{ .Values.vault.env }}
vault.hashicorp.com/agent-inject-template-env: |
  {{ `{{ with secret "` }}{{ .Values.vault.env }}{{`"  -}}
  {{ range $k, $v := .Data.data -}}
  export {{ $k }}='{{ $v }}'
  {{ end -}}
  {{ end -}}` }}
{{- end -}}


{{/*
Headers for liveness probe healthcheck
*/}}
{{- define "node.application.healthcheck.headers" -}}
  {{- if .Values.application.healthcheck.headers }}
  httpHeaders:
  {{- range .Values.application.healthcheck.headers }}
    - name: {{ .name }}
      value: {{ .value }}
  {{- end }}
  {{- end }}
{{- end -}}

{{/*
Extra volume mounts
*/}}
{{- define "node.application.extraConfigmapMounts" -}}
{{- range .Values.application.extraVolumes }}
- name: {{ .name }}
  mountPath: {{ .mountPath }}
  {{- if .subPath }}
  subPath: {{ .subPath }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Extra volumes
*/}}
{{- define "node.application.extraConfigmapVolumes" -}}
{{- range .Values.application.extraVolumes }}
- name: {{ .name }}
  {{- if eq .type "configMap" }}
  configMap:
    name: {{ .configMapName }}
  {{- else }}
  emptyDir: {}
  {{- end }}
{{- end }}
{{- end -}}
