{{/*
OC ca mount

*/}}
{{- define "oc.caPath" -}}
{{- if .Values.customCAChain.enabled }}
- name: custom-ca-chain
  mountPath: /etc/ssl/custom/
  readOnly: true
{{- end }}
{{- end -}}

{{- define "oc.caVolume" -}}
{{- if .Values.customCAChain.enabled }}
- name: custom-ca-chain
  configMap:
    name: {{ required "customCAChain.existingConfigMap needs to be configured when customCAChain.enabled is set to true" .Values.customCAChain.existingConfigMap | quote }}
{{- end }}
{{- end -}}

{{- define "oc.caEnv" -}}
{{- if .Values.customCAChain.enabled }}
- name: SSL_CERT_DIR
  value: "/etc/ssl/certs:/etc/ssl/custom"
{{- end }}
{{- end -}}
