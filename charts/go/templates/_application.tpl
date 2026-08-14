{{/*
Application Name
*/}}
{{- define "go.application.name" -}}
  {{ .Values.application.name | required "Required: Application Name << .Values.application.name >>" | lower }}
{{- end -}}

{{/*
Define the container image urls
*/}}
{{- define "go.application.imageURL" -}}
  {{- printf "%s/%s:%s" (include "go.cloud.containerRegistryURL" .) .Values.application.image.repository (.Values.application.image.tag | required "An image tag needs to be defined.") }}
{{- end -}}

{{/*
Define container security context
*/}}
{{- define "go.application.securityContext" -}}
runAsUser: {{ .Values.application.securityContext.runAsUser }}
runAsGroup: {{ .Values.application.securityContext.runAsGroup }}
runAsNonRoot: true
readOnlyRootFilesystem: {{ .Values.application.readOnly }}
allowPrivilegeEscalation: false
{{- end }}

{{/*
Renders a probe. gRPC services (deployment.grpc: true) use the grpc_health_probe
binary; everything else uses an HTTP GET against the container port. Pass the
probe config in as "probe" and the root context as "ctx".
*/}}
{{- define "go.application.probe" -}}
{{- $ctx := .ctx -}}
{{- $probe := .probe -}}
{{- if $ctx.Values.deployment.grpc -}}
exec:
  command: ["/go/bin/grpc_health_probe", "-addr=:{{ $ctx.Values.deployment.containerPort }}"]
{{- else if eq $probe.type "tcp" -}}
tcpSocket:
  port: {{ $ctx.Values.deployment.containerPort }}
{{- else -}}
httpGet:
  port: {{ $ctx.Values.deployment.containerPort }}
  path: {{ $probe.path }}
  {{- with $probe.httpHeaders }}
  httpHeaders:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
initialDelaySeconds: {{ $probe.initialDelaySeconds }}
timeoutSeconds: {{ $probe.timeoutSeconds }}
{{- with $probe.periodSeconds }}
periodSeconds: {{ . }}
{{- end }}
{{- with $probe.failureThreshold }}
failureThreshold: {{ . }}
{{- end }}
{{- end }}

{{/*
Vault Agent Annotations
*/}}
{{- define "go.application.vault.annotations" -}}
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
{{- define "go.application.healthcheck.headers" -}}
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
{{- define "go.application.extraConfigmapMounts" -}}
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
{{- define "go.application.extraConfigmapVolumes" -}}
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
Container environment. Shared by the deployment and the job so a job running the
same image gets the same configuration.

A default the service also sets is dropped rather than emitted twice — the API
server rejects a container with two env entries of the same name, so without
this a service could only avoid the collision by not setting the variable.
*/}}
{{- define "go.application.env" -}}
{{- $overridden := dict -}}
{{- range .Values.application.env }}{{- $_ := set $overridden .name true -}}{{- end }}
{{- $defaults := list
    (dict "name" "APP_NAME" "value" (.Values.application.name | lower))
    (dict "name" "PLATFORM" "value" (include "go.cloud.provider" .)) }}
{{- if eq (include "go.cloud.provider" .) "AWS" }}
{{- $defaults = append $defaults (dict "name" "AWS_REGION" "value" .Values.cloud.region) }}
{{- end }}
{{- range $default := $defaults }}
{{- if not (hasKey $overridden $default.name) }}
- name: {{ $default.name }}
  value: {{ $default.value | quote }}
{{- end }}
{{- end }}
{{- range .Values.application.env }}
- name: "{{ .name }}"
  value: "{{ .value }}"
{{- end }}
{{- end }}
