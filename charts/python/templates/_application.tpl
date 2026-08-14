{{/*
Application Name
*/}}
{{- define "python.application.name" -}}
  {{ .Values.application.name | required "Required: Application Name << .Values.application.name >>" | lower }}
{{- end -}}

{{/*
Define the container image urls
*/}}
{{- define "python.application.imageURL" -}}
  {{- printf "%s/%s:%s" (include "python.cloud.containerRegistryURL" .) .Values.application.image.repository (.Values.application.image.tag | required "An image tag needs to be defined.") }}
{{- end -}}

{{/*
Define container security context
*/}}
{{- define "python.application.securityContext" -}}
runAsUser: 1000
runAsGroup: 1000
runAsNonRoot: true
readOnlyRootFilesystem: true
allowPrivilegeEscalation: false
{{- end }}

{{/*
Vault Agent Annotations
*/}}
{{- define "python.application.vault.annotations" -}}
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-pre-populate: "true"
vault.hashicorp.com/agent-pre-populate-only: "true"
vault.hashicorp.com/agent-init-first: "true"
vault.hashicorp.com/role: {{ .Values.vault.role }}
vault.hashicorp.com/agent-inject-secret-env: {{ .Values.vault.env }}
vault.hashicorp.com/agent-inject-template-env: |
  {{- if .Values.vault.sharedEnv }}
  {{ `{{ with secret "` }}{{ .Values.vault.sharedEnv }}{{`"  -}}
  {{ range $k, $v := .Data.data -}}
  export {{ $k }}='{{ $v }}'
  {{ end -}}
  {{ end -}}` }}
  {{- end }}
  {{ `{{ with secret "` }}{{ .Values.vault.env }}{{`"  -}}
  {{ range $k, $v := .Data.data -}}
  export {{ $k }}='{{ $v }}'
  {{ end -}}
  {{ end -}}` }}
{{- end -}}


{{/*
Headers for liveness probe healthcheck
*/}}
{{- define "python.application.healthcheck.headers" -}}
  {{- if .Values.application.healthcheck.headers -}}
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
{{- define "python.application.extraConfigmapMounts" -}}
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
{{- define "python.application.extraConfigmapVolumes" -}}
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


{{/*
Environment for a container: the chart's defaults, then the service's own.

A default the service also sets is dropped rather than emitted twice — the API
server rejects a container with two env entries of the same name, so without
this a service could only avoid the collision by not setting the variable at
all.
*/}}
{{- define "python.application.env" -}}
{{- $overridden := dict -}}
{{- range .env }}{{- $_ := set $overridden .name true -}}{{- end }}
{{- range $default := .defaults }}
{{- if not (hasKey $overridden $default.name) }}
- name: {{ $default.name }}
  value: {{ $default.value | quote }}
{{- end }}
{{- end }}
{{- range .env }}
- name: "{{ .name }}"
  value: "{{ .value }}"
{{- end }}
{{- end -}}
