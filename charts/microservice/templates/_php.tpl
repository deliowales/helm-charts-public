{{/*
PHP volumes
*/}}
{{- define "microservice.php.volumes" -}}
- name: fpm-pool-config-volume
  configMap:
    name: fpm-pool-configmap
- name: php-config-volume
  configMap:
    name: php-configmap
- name: nginx-config-volume
  configMap:
    name: nginx-configmap
- name: shared-files
  emptyDir: {}
- name: tmp
  emptyDir: {}
- name: newrelic-log
  emptyDir: {}
{{- if eq .Values.supervisor.enabled true }}
- name: supervisor-config-volume
  configMap:
    name: supervisor-configmap
- name: supervisor-logs
  emptyDir: {}
{{- end }}
{{- end -}}

{{/*
PHP volumes mounts
*/}}
{{- define "microservice.php.volumeMounts" -}}
- name: fpm-pool-config-volume
  mountPath: /usr/local/etc/php-fpm.d/www.conf
  subPath: www.conf
- name: php-config-volume
  mountPath: /usr/local/etc/php/php.ini
  subPath: php.ini
- name: shared-files
  mountPath: /service
- name: tmp
  mountPath: /tmp
- name: newrelic-log
  mountPath: /var/log/newrelic/
{{- if eq .Values.supervisor.enabled true }}
- name: supervisor-config-volume
  mountPath: /etc/supervisord-tmp.conf
  subPath: supervisord-tmp.conf
- name: supervisor-logs
  mountPath: /home/app
{{- end }}
{{- end -}}

{{/*
PHP healthchecks
*/}}
{{- define "microservice.php.healthchecks" -}}
- name: fpm-pool-config-volume
  mountPath: /usr/local/etc/php-fpm.d/www.conf
  subPath: www.conf
- name: php-config-volume
  mountPath: /usr/local/etc/php/php.ini
  subPath: php.ini
- name: shared-files
  mountPath: /service
- name: tmp
  mountPath: /tmp
- name: newrelic-log
  mountPath: /var/log/newrelic/
{{- if eq .Values.supervisor.enabled true }}
- name: supervisor-config-volume
  mountPath: /etc/supervisord-tmp.conf
  subPath: supervisord-tmp.conf
- name: supervisor-logs
  mountPath: /home/app
{{- end }}
{{- end -}}
