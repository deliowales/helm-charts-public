{{/*
Logging fluentbit image
*/}}
{{- define "microservice.logging.imageURL" -}}
  {{- printf "%s/%s:%s" .Values.cloud.containerRegistryURL .Values.logging.image.repository .Values.logging.image.tag }}
{{- end -}}

{{/*
Logging container for php services
*/}}
{{- define "microservice.logging.container" -}}
- name: logs
  image: {{ include "microservice.logging.imageURL" . }}
  imagePullPolicy: IfNotPresent
  resources:
  {{- toYaml .Values.logging.resources | nindent 4 }}
  securityContext:
    runAsNonRoot: true
    readOnlyRootFilesystem: true
    runAsUser: 1001
    runAsGroup: 1001
  env:
   {{- include "microservice.logging.env" . | nindent 4 }}
  volumeMounts:
    - name: shared-files
      mountPath: /code
{{- end }}

{{/*
Logging container for php services
*/}}
{{- define "microservice.logging.env" -}}
- name: PLATFORM
  value: {{ include "microservice.cloud.provider" . }}
- name: DOCKER_IMAGE
  value: {{ include "microservice.application.imageURL" . }}
- name: ENVIRONMENT
  value: {{ include "microservice.cloud.environment" . }}
- name: NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: HOST_IP
  valueFrom:
    fieldRef:
      fieldPath: status.podIP
- name: POD_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: NEW_RELIC_LICENSE_KEY
  value: {{ .Values.newrelic.licenseKey }}
- name: FLUENT_BIT_LOG_PATH
  value: {{ .Values.logging.logPath }}
- name: FLUENT_BIT_PARSER_PATH
  value: {{ .Values.logging.parserPath }}
- name: FLUENT_BIT_MULTILINE
  value: {{ .Values.logging.multiLine | quote }}
{{- end }}
