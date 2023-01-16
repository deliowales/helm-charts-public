{{/*
Application Name
*/}}
{{- define "php.logs" -}}
  - name: logs
    image: "{{ include "php.logging.imageURL" . }}"
    imagePullPolicy: IfNotPresent
    resources:
      {{- toYaml .Values.logging.resources | nindent 12 }}
    securityContext:
      runAsNonRoot: true
      readOnlyRootFilesystem: true
      runAsUser: 1001
      runAsGroup: 1001
    env:
      - name: PLATFORM
        value: "{{ include "php.cloud.provider" . }}"
      - name: DOCKER_IMAGE
        value: "{{ include "php.application.imageURL" . }}"
      - name: ENVIRONMENT
        value: "{{ include "php.cloud.environment" . }}"
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
    volumeMounts:
      - name: shared-files
        mountPath: /var/www/html
{{- end -}}
