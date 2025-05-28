{{/*
imagePullSecrets logic
*/}}
{{- define "oc.imagePullSecrets" -}}
  {{- with $.Values.image.pullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end -}}


{{/*
image template helper

@param .repo        The image repository
@param .tag         The image tag
@param .sha         The image sha checksum
@param .pullPolicy  The image pullPolicy
*/}}
{{- define "oc.imageTemplateHelper" -}}
  {{ if .sha -}}
image: "{{ .repo }}:{{ .tag }}@sha256:{{ .sha }}"
  {{- else -}}
image: "{{ .repo }}:{{ .tag }}"
  {{- end }}
imagePullPolicy: {{ .pullPolicy }}
{{- end -}}

{{/*
OC image logic
*/}}
{{- define "oc.image" -}}
{{- $repo := default $.Values.image.repository .appSpecificConfig.image.repository -}}
{{- $tag := default (default $.Chart.AppVersion $.Values.image.tag) .appSpecificConfig.image.tag -}}
{{- $sha := default $.Values.image.sha .appSpecificConfig.image.sha -}}
{{- $pullPolicy := default $.Values.image.pullPolicy .appSpecificConfig.image.pullPolicy -}}
{{ template "oc.imageTemplateHelper" (dict "repo" $repo "tag" $tag "sha" $sha "pullPolicy" $pullPolicy) }}
{{- end -}}

{{/*
jobContainerOC image logic for OC based containers
*/}}
{{- define "oc.jobContainerImageOC" -}}
{{- $repo := default $.Values.image.repository .appSpecificConfig.maintenance.image.repository -}}
{{- $tag := default (default $.Chart.AppVersion $.Values.image.tag) .appSpecificConfig.maintenance.image.tag -}}
{{- $sha := default $.Values.image.sha .appSpecificConfig.maintenance.image.sha -}}
{{- $pullPolicy := default $.Values.image.pullPolicy .appSpecificConfig.maintenance.image.pullPolicy -}}
{{ template "oc.imageTemplateHelper" (dict "repo" $repo "tag" $tag "sha" $sha "pullPolicy" $pullPolicy) }}
{{- end -}}

{{/*
initContainer image logic
*/}}
{{- define "oc.initContainerImage" -}}
{{- $repo := $.Values.initContainerImage.repository -}}
{{- $tag := default "latest" $.Values.initContainerImage.tag -}}
{{- $sha := $.Values.initContainerImage.sha -}}
{{- $pullPolicy := $.Values.initContainerImage.pullPolicy -}}
{{ template "oc.imageTemplateHelper" (dict "repo" $repo "tag" $tag "sha" $sha "pullPolicy" $pullPolicy) }}
{{- end -}}

{{/*
jobContainer image logic for non OC based containers
*/}}
{{- define "oc.jobContainerImage" -}}
{{- $repo := .appSpecificConfig.maintenance.image.repository -}}
{{- $tag := .appSpecificConfig.maintenance.image.tag -}}
{{- $sha := .appSpecificConfig.maintenance.image.sha -}}
{{- $pullPolicy := .appSpecificConfig.maintenance.image.pullPolicy -}}
{{ template "oc.imageTemplateHelper" (dict "repo" $repo "tag" $tag "sha" $sha "pullPolicy" $pullPolicy) }}
{{- end -}}
