{{- define "python.deployment.topologySpreadConstraints" -}}
  topologySpreadConstraints:
  - maxSkew: {{ .Values.deployment.topologySpreadConstraints.maxSkew }}
    topologyKey: {{ .Values.deployment.topologySpreadConstraints.topologyKey }}
    whenUnsatisfiable: {{ .Values.deployment.topologySpreadConstraints.whenUnsatisfiable }}
    # Scopes the skew calculation to the revision being rolled out. Without it the
    # old ReplicaSet's pods still count while they terminate, so the scheduler
    # measures balance against a moving target and the new pods land wherever the
    # stale numbers point. Kubernetes 1.27+.
    matchLabelKeys:
      - pod-template-hash
    labelSelector:
      matchLabels:
        app.kubernetes.io/name: {{ .Values.application.name | lower }}
{{- end }}

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