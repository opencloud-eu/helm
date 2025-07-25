{{/*
Expand the name of the chart.
*/}}
{{- define "oc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "oc.labels" -}}
helm.sh/chart: {{ include "oc.chart" . }}
{{ include "oc.selectorLabels" . }}
{{- if or .Chart.AppVersion .Values.image.tag }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.extraLabels }}
{{ toYaml .Values.extraLabels }}
{{- end }}

{{- with and .appSpecificConfig .appSpecificConfig.extraLabels }}
{{ toYaml . }}
{{- end }}

{{- end -}}

{{/*
Selector labels
*/}}
{{- define "oc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
