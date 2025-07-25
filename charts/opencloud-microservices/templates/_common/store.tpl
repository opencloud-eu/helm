{{/*
OC store configuration
*/}}

{{- define "oc.persistentStore" -}}
{{- $valid := list "memory" "redis-sentinel" "nats-js-kv" -}}
{{- if not (has .Values.store.type $valid) -}}
{{- fail "invalid store.type set" -}}
{{- end -}}
- name: OC_PERSISTENT_STORE
  value: {{ .Values.store.type | quote }}
- name: OC_PERSISTENT_STORE_NODES
  value: {{ tpl (join "," .Values.store.nodes) . | quote }}
{{- end -}}

{{- define "oc.cacheStore" -}}
{{- $valid := list "noop" "memory" "nats-js-kv" "redis-sentinel" -}}
{{- if not (has .Values.cache.type $valid) -}}
{{- fail "invalid cache.type set" -}}
{{- end -}}
- name: OC_CACHE_STORE
  value: {{ .Values.cache.type | quote }}
{{- if ne .Values.cache.type "noop" }}
- name: OC_CACHE_STORE_NODES
  value: {{ tpl (join "," .Values.cache.nodes) . | quote }}
- name: OC_CACHE_DISABLE_PERSISTENCE
  value: "true"
{{- end }}
{{- end -}}
