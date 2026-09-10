{{- define "node.deployment.topologySpreadConstraints" -}}
{{- $spread := .Values.deployment.topologySpreadConstraints -}}
{{- $all := ternary $spread (list $spread) (kindIs "slice" $spread) -}}
topologySpreadConstraints:
{{- range $all }}
  - maxSkew: {{ .maxSkew }}
    topologyKey: {{ .topologyKey }}
    whenUnsatisfiable: {{ .whenUnsatisfiable }}
    # Scopes the skew calculation to the revision being rolled out. Without it the
    # old ReplicaSet's pods still count while they terminate, so the scheduler
    # measures balance against a moving target and the new pods land wherever the
    # stale numbers point. Kubernetes 1.27+.
    matchLabelKeys:
      - pod-template-hash
    labelSelector:
      matchLabels:
        app.kubernetes.io/name: {{ $.Values.application.name | lower }}
{{- end }}
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
