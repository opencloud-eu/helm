{{/*
OC events configuration
*/}}

{{- define "oc.events" -}}
{{- if not .Values.messagingSystem.external.enabled }}
- name: OC_EVENTS_ENDPOINT
  value: {{ .appNameNats }}:9233
{{- else }}
{{- $oc_events_endpoint := .Values.messagingSystem.external.endpoint | required ".Values.messagingSystem.external.endpoint is required when .Values.messagingSystem.external.enabled is set to true." -}}
{{- $oc_events_cluster := .Values.messagingSystem.external.cluster | required ".Values.messagingSystem.external.cluster is required when .Values.messagingSystem.external.enabled is set to true." -}}
- name: OC_EVENTS_ENDPOINT
  value: {{ $oc_events_endpoint | quote }}
- name: OC_EVENTS_CLUSTER
  value: {{ $oc_events_cluster | quote }}
- name: OC_EVENTS_ENABLE_TLS
  value: {{ .Values.messagingSystem.external.tls.enabled | quote }}
- name: OC_EVENTS_TLS_INSECURE
  value: {{ .Values.messagingSystem.external.tls.insecure | quote }}
- name: OC_EVENTS_TLS_ROOT_CA_CERTIFICATE
  {{- if not .Values.messagingSystem.external.tls.certTrusted }}
  value: /etc/opencloud/messaging-system-ca/messaging-system-ca.crt
  {{- else }}
  value: "" # no cert needed
  {{- end }}
{{- end }}
{{- end -}}
