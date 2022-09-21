{{/*
Node volumes
*/}}
{{- define "microservice.node.volumes" -}}
- name: tmp
  emptyDir: {}
{{- if eq .Values.clamAV.enabled true}}
- name: clamd
  emptyDir: {}
- name: clamlogs
  emptyDir: {}
- name: clamavtmp
  emptyDir: {}
{{- end }}
{{- end -}}

{{/*
Node volumes mounts
*/}}
{{- define "microservice.node.volumeMounts" -}}
- name: tmp
  mountPath: /tmp
{{- if eq .Values.clamAV.enabled true}}
- name: clamd
  mountPath: /run/clamav
- name: clamlogs
  mountPath: /var/log/clamav
- name: clamavtmp
  mountPath: /var/lib/clamav
{{- end }}
{{- end -}}

{{/*
Node liveness probe
*/}}
{{- define "microservice.node.livenessProbe" -}}
readinessProbe:
  httpGet:
    port: {{ include "microservice.application.containerPort" . }}
    path: {{ .Values.application.readinessProbe.path }}
{{- end -}}
