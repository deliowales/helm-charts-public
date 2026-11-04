{{/*
The php container's memory limit in Mi, or 0 when none is set.
*/}}
{{- define "php.fpm.memoryLimitMi" -}}
{{- $limit := toString (.Values.application.resources.limits.memory | default "") -}}
{{- if not $limit -}}
0
{{- else -}}
{{- if not (regexMatch "^[0-9]+(\\.[0-9]+)?(Ki|Mi|Gi|Ti|k|M|G|T)?$" $limit) -}}
{{- fail (printf "application.resources.limits.memory %q is not a quantity the fpm pool can be sized from" $limit) -}}
{{- end -}}
{{- $amount := regexFind "^[0-9.]+" $limit | float64 -}}
{{- $unit := trimPrefix (regexFind "^[0-9.]+" $limit) $limit -}}
{{- $miPerUnit := dict "" 0.00000095367431640625 "Ki" 0.0009765625 "Mi" 1.0 "Gi" 1024.0 "Ti" 1048576.0 "k" 0.00095367431640625 "M" 0.95367431640625 "G" 953.67431640625 "T" 953674.31640625 -}}
{{- mulf $amount (get $miPerUnit $unit) | floor | int -}}
{{- end -}}
{{- end -}}

{{- define "php.fpm.maxChildren" -}}
{{- if .Values.fpm.maxChildren -}}
{{ .Values.fpm.maxChildren }}
{{- else -}}
{{- $limitMi := include "php.fpm.memoryLimitMi" . | atoi -}}
{{- $fits := div (sub $limitMi 60) (int .Values.fpm.workerMemoryMi) -}}
{{- $fits | max 5 | min 32 -}}
{{- end -}}
{{- end -}}

{{- define "php.fpm.minSpareServers" -}}
{{- if .Values.fpm.minSpareServers -}}
{{ .Values.fpm.minSpareServers }}
{{- else -}}
{{- div (include "php.fpm.maxChildren" . | atoi) 10 | max 1 -}}
{{- end -}}
{{- end -}}

{{- define "php.fpm.maxSpareServers" -}}
{{- if .Values.fpm.maxSpareServers -}}
{{ .Values.fpm.maxSpareServers }}
{{- else -}}
{{- div (mul (include "php.fpm.maxChildren" . | atoi) 3) 10 | max 3 -}}
{{- end -}}
{{- end -}}

{{/*
php-fpm's own default for start_servers when it is left out.
*/}}
{{- define "php.fpm.startServers" -}}
{{- if .Values.fpm.startServers -}}
{{ .Values.fpm.startServers }}
{{- else -}}
{{- $min := include "php.fpm.minSpareServers" . | atoi -}}
{{- $max := include "php.fpm.maxSpareServers" . | atoi -}}
{{- add $min (div (sub $max $min) 2) -}}
{{- end -}}
{{- end -}}

{{/*
php-fpm refuses to start on these, so catch them at render time instead of in a
crashlooping pod.
*/}}
{{- define "php.fpm.validateDynamic" -}}
{{- $children := include "php.fpm.maxChildren" . | atoi -}}
{{- $min := include "php.fpm.minSpareServers" . | atoi -}}
{{- $max := include "php.fpm.maxSpareServers" . | atoi -}}
{{- $start := include "php.fpm.startServers" . | atoi -}}
{{- if gt $max $children -}}
{{- fail (printf "fpm.maxSpareServers (%d) must not exceed fpm.maxChildren (%d)" $max $children) -}}
{{- end -}}
{{- if gt $min $max -}}
{{- fail (printf "fpm.minSpareServers (%d) must not exceed fpm.maxSpareServers (%d)" $min $max) -}}
{{- end -}}
{{- if or (lt $start $min) (gt $start $max) -}}
{{- fail (printf "fpm.startServers (%d) must sit between fpm.minSpareServers (%d) and fpm.maxSpareServers (%d)" $start $min $max) -}}
{{- end -}}
{{- end -}}
