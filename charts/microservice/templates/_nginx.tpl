
{{/*
Logging container for php services
*/}}
{{- define "microservice.nginx.container" -}}
- name: nginx
  image: {{ include "microservice.deployment.nginx.imageURL" . }}
  imagePullPolicy: IfNotPresent
  securityContext:
    runAsNonRoot: true
    readOnlyRootFilesystem: true
  lifecycle:
    postStart:
      exec:
        command: ["sh"]
  ports:
    - name: http
      containerPort: {{ .Values.nginx.service.internalPort }}
  resources:
    {{- toYaml .Values.nginx.resources | nindent 12 }}
  livenessProbe:
    httpGet:
      port: {{ include "microservice.application.containerPort" . }}
      path: {{ .Values.nginx.livenessProbe.path }}
      {{- if .Values.nginx.livenessProbe.httpHeaders }}
      httpHeaders:
      {{- range .Values.nginx.livenessProbe.httpHeaders }}
        - name: {{ .name }}
          value: {{ .value }}
      {{- end }}
      {{- end }}
    initialDelaySeconds: 10
    timeoutSeconds: 5
  readinessProbe:
    httpGet:
      port: {{ include "microservice.application.containerPort" . }}
      path: {{ .Values.nginx.readinessProbe.path }}
      {{- if .Values.nginx.readinessProbe.httpHeaders }}
      httpHeaders:
      {{- range .Values.nginx.readinessProbe.httpHeaders }}
        - name: {{ .name }}
          value: {{ .value }}
      {{- end }}
      {{- end }}
    initialDelaySeconds: 5
    timeoutSeconds: 1
  volumeMounts:
    {{- include "microservice.nginx.volumeMounts" . | nindent 8 }}
{{- end }}

{{/*
PHP volumes mounts
*/}}
{{- define "microservice.nginx.volumeMounts" -}}
- name: nginx-config-volume
  mountPath: /etc/nginx/conf.d/default.conf
  subPath: default.conf
- name: shared-files
  mountPath: /service
- name: tmp
  mountPath: /tmp
{{- end -}}
