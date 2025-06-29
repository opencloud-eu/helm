{{/* vim: set filetype=mustache: */}}
{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" .) }}
*/}}
{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
See also https://github.com/helm/helm/issues/5465
*/}}
{{- define "oc.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oc.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified MinIO name.
*/}}
{{- define "oc.minio.fullname" -}}
{{- printf "%s-minio" (include "oc.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a fully qualified Keycloak name.
*/}}
{{- define "oc.keycloak.fullname" -}}
{{- printf "%s-keycloak" (include "oc.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a fully qualified OnlyOffice name.
*/}}
{{- define "oc.onlyoffice.fullname" -}}
{{- printf "%s-onlyoffice" (include "oc.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}



{{/*
Adds the app names to the scope and set the name of the app based on the input parameters

@param .scope          The current scope
@param .appName        The name of the current app
@param .appNameSuffix  The suffix to be added to the appName (if needed)
*/}}
{{- define "oc.basicServiceTemplates" -}}
  {{- $_ := set .scope "appNameActivitylog" "activitylog" -}}
  {{- $_ := set .scope "appNameAppRegistry" "appregistry" -}}
  {{- $_ := set .scope "appNameAudit" "audit" -}}
  {{- $_ := set .scope "appNameAuthMachine" "authmachine" -}}
  {{- $_ := set .scope "appNameAuthApp" "authapp" -}}
  {{- $_ := set .scope "appNameAuthService" "authservice" -}}
  {{- $_ := set .scope "appNameAntivirus" "antivirus" -}}
  {{- $_ := set .scope "appNameClientlog" "clientlog" -}}
  {{- $_ := set .scope "appNameCollaboration" "collaboration" -}}
  {{- $_ := set .scope "appNameEventhistory" "eventhistory" -}}
  {{- $_ := set .scope "appNameFrontend" "frontend" -}}
  {{- $_ := set .scope "appNameGateway" "gateway" -}}
  {{- $_ := set .scope "appNameGraph" "graph" -}}
  {{- $_ := set .scope "appNameGroups" "groups" -}}
  {{- $_ := set .scope "appNameIdm" "idm" -}}
  {{- $_ := set .scope "appNameIdp" "idp" -}}
  {{- $_ := set .scope "appNameKeycloak" "keycloak" -}}
  {{- $_ := set .scope "appNameKeycloakPG" "keycloak-postgresql" -}}
  {{- $_ := set .scope "appNameMinio" "minio" -}}
  {{- $_ := set .scope "appNameNats" "nats" -}}
  {{- $_ := set .scope "appNameNotifications" "notifications" -}}
  {{- $_ := set .scope "appNameOcdav" "ocdav" -}}
  {{- $_ := set .scope "appNameOcm" "ocm" -}}
  {{- $_ := set .scope "appNameOcs" "ocs" -}}
  {{- $_ := set .scope "appNameOnlyOffice" "onlyoffice" -}}
  {{- $_ := set .scope "appNameCollabora" "collabora" -}}
  {{- $_ := set .scope "appNamePolicies" "policies" -}}
  {{- $_ := set .scope "appNamePostprocessing" "postprocessing" -}}
  {{- $_ := set .scope "appNameProxy" "proxy" -}}
  {{- $_ := set .scope "appNameSearch" "search" -}}
  {{- $_ := set .scope "appNameSettings" "settings" -}}
  {{- $_ := set .scope "appNameSharing" "sharing" -}}
  {{- $_ := set .scope "appNameSSE" "sse" -}}
  {{- $_ := set .scope "appNameStoragePubliclink" "storagepubliclink" -}}
  {{- $_ := set .scope "appNameStorageShares" "storageshares" -}}
  {{- $_ := set .scope "appNameStorageUsers" "storageusers" -}}
  {{- $_ := set .scope "appNameStorageSystem" "storagesystem" -}}
  {{- $_ := set .scope "appNameStore" "store" -}}
  {{- $_ := set .scope "appNameThumbnails" "thumbnails" -}}
  {{- $_ := set .scope "appNameTika" "tika" -}}
  {{- $_ := set .scope "appNameUserlog" "userlog" -}}
  {{- $_ := set .scope "appNameUsers" "users" -}}
  {{- $_ := set .scope "appNameWeb" "web" -}}
  {{- $_ := set .scope "appNameWebdav" "webdav" -}}
  {{- $_ := set .scope "appNameWebfinger" "webfinger" -}}

  {{- if .appNameSuffix -}}
  {{- $_ := set .scope "appName" (print (index .scope .appName) "-" .appNameSuffix) -}}
  {{- else -}}
  {{- $_ := set .scope "appName" (index .scope .appName) -}}
  {{- end -}}

  {{- if (index .scope.Values.services (index .scope .appName)) -}}
  {{- $_ := set .scope "appSpecificConfig" (index .scope.Values.services (index .scope .appName)) -}}
  {{- end -}}

  {{- $_ := set .scope "affinity" .scope.appSpecificConfig.affinity -}}
  {{- $_ := set .scope "priorityClassName" (default (default (dict) .scope.Values.priorityClassName) .scope.appSpecificConfig.priorityClassName) -}}
  {{- $_ := set .scope "jobPriorityClassName" (default (default (dict) .scope.Values.jobPriorityClassName) .scope.appSpecificConfig.jobPriorityClassName) -}}

  {{- $_ := set .scope "nodeSelector" (default (default (dict) .scope.Values.nodeSelector) .scope.appSpecificConfig.nodeSelector) -}}
  {{- $_ := set .scope "jobNodeSelector" (default (default (dict) .scope.Values.jobNodeSelector) .scope.appSpecificConfig.jobNodeSelector) -}}

  {{- $_ := set .scope "resources" (default (default (dict) .scope.Values.resources) .scope.appSpecificConfig.resources) -}}
  {{- $_ := set .scope "jobResources" (default (default (dict) .scope.Values.jobResources) .scope.appSpecificConfig.jobResources) -}}

{{- end -}}

{{/*
OC PDB template

*/}}
{{- define "oc.pdb" -}}
{{- $_ := set . "podDisruptionBudget" (default (default (dict) .Values.podDisruptionBudget) (index .Values.services (split "-" .appName)._0).podDisruptionBudget) -}}
{{ if .podDisruptionBudget }}
apiVersion: policy/v1
kind: PodDisruptionBudget
{{ include "oc.metadata" . }}
spec:
  {{- toYaml .podDisruptionBudget | nindent 2 }}
  {{- include "oc.selector" . | nindent 2 }}
{{- end }}
{{- end -}}

{{- define "oc.hpa" -}}
{{- if .autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
{{ include "oc.metadata" . }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .appName }}
  minReplicas: {{ .autoscaling.minReplicas }}
  maxReplicas: {{ .autoscaling.maxReplicas }}
  metrics:
{{ toYaml .autoscaling.metrics | indent 4 }}
{{- end }}
{{- end -}}

{{- define "oc.affinity" -}}
{{- with .affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}

{{- define "oc.priorityClassName" -}}
{{- if . }}
priorityClassName: {{ . | quote }}
{{- end }}
{{- end -}}
{{/*

{{/*
OC security Context template

*/}}
{{- define "oc.securityContextAndtopologySpreadConstraints" -}}
securityContext:
    fsGroup: {{ .Values.securityContext.fsGroup }}
    fsGroupChangePolicy: {{ .Values.securityContext.fsGroupChangePolicy }}
{{- with .Values.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- tpl . $ | nindent 8 }}
{{- end }}
{{- end -}}

{{/*
OC deployment metadata template

*/}}
{{- define "oc.metadata" -}}
metadata:
  name: {{ .appName }}
  namespace: {{ template "oc.namespace" . }}
  labels:
    {{- include "oc.labels" . | nindent 4 }}
  {{- with .Values.extraAnnotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}

{{/*
OC deployment selector template

*/}}
{{- define "oc.selector" -}}
selector:
  matchLabels:
    app: {{ .appName }}
{{- end -}}

{{/*
OC deployment container securityContext template

*/}}
{{- define "oc.containerSecurityContext" -}}
securityContext:
  runAsNonRoot: true
  runAsUser: {{ .Values.securityContext.runAsUser }}
  runAsGroup: {{ .Values.securityContext.runAsGroup }}
  readOnlyRootFilesystem: true
{{- end -}}

{{/*
OC deployment template metadata template

@param .scope          The current scope
@param .configCheck    If this pod contains a configMap which has to be checked to trigger pod redeployment
*/}}
{{- define "oc.templateMetadata" -}}
metadata:
  labels:
    app: {{ .scope.appName }}
    {{- include "oc.labels" .scope | nindent 4 }}
  {{- if .configCheck }}
  annotations:
    checksum/config: {{ include (print .scope.Template.BasePath "/" .scope.appName "/config.yaml") .scope | sha256sum }}
  {{- end }}
{{- end -}}

{{/*
OC deployment container livenessProbe template

*/}}
{{- define "oc.livenessProbe" -}}
livenessProbe:
  httpGet:
    path: /healthz
    port: metrics-debug
  timeoutSeconds: 10
  initialDelaySeconds: 60
  periodSeconds: 20
  failureThreshold: 3
{{- end -}}

{{/*
OC deployment strategy
*/}}
{{- define "oc.deploymentStrategy" -}}
  {{- with $.Values.deploymentStrategy }}
strategy:
  type: {{ .type }}
  {{- if eq .type "RollingUpdate" }}
  rollingUpdate:
  {{- toYaml .rollingUpdate | nindent 4 }}
  {{- end }}
  {{- end }}
{{- end -}}

{{/*
OC deployment CORS template

*/}}
{{- define "oc.cors" -}}
{{- $origins := .Values.http.cors.allow_origins -}}
{{- if not (has "https://{{ .Values.externalDomain }}" $origins) -}}
{{- $origins = prepend $origins (print "https://" .Values.externalDomain) -}}
{{- end -}}
- name: OC_CORS_ALLOW_ORIGINS
  value: {{ without $origins "" | join "," | quote }}
{{- end -}}

{{/*
OC hostAliases settings
*/}}
{{- define "oc.hostAliases" -}}
  {{- with $.Values.hostAliases }}
hostAliases:
  {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end -}}

{{/*
OC persistence dataVolumeName
*/}}
{{- define "oc.persistence.dataVolumeName" -}}
{{ (index .Values.services .appName).persistence.claimName | default ( printf "%s-data" .appName ) }}
{{- end -}}

{{/*
OC persistence dataVolume
*/}}
{{- define "oc.persistence.dataVolume" -}}
- name: {{ include "oc.persistence.dataVolumeName" . }}
  {{- if (index .Values.services .appName).persistence.enabled }}
  persistentVolumeClaim:
    claimName: {{ (index .Values.services .appName).persistence.existingClaim | default ( include "oc.persistence.dataVolumeName" . ) }}
  {{- else }}
  emptyDir: {}
  {{- end }}
{{- end -}}

{{/*
OC secret wrapper

@param .name          The name of the secret.
@param .params        Dict containing data keys/values (plaintext).
@param .labels        Dict containing labels key/values.
@param .scope         The current scope
*/}}
{{- define "oc.secret" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .name }}
  labels:
    {{- range $key, $value := .labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
  annotations:
    helm.sh/resource-policy: keep
data:
  {{- $secretObj := (lookup "v1" "Secret" .scope.Release.Namespace .name) | default dict }}
  {{- $secretData := (get $secretObj "data") | default dict }}
  {{- range $key, $value := .params }}
  {{- $secretValue := (get $secretData $key) | default ($value | b64enc)}}
  {{ $key }}: {{ $secretValue | quote }}
  {{- end }}
{{- end -}}

{{/*
OC ConfigMap wrapper

@param .name          The name of the ConfigMap.
@param .params        Dict containing data keys/values (plaintext).
@param .labels        Dict containing labels key/values.
@param .scope         The current scope
*/}}
{{- define "oc.configMap" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .name }}
  labels:
    {{- range $key, $value := .labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
data:
  {{- $configObj := (lookup "v1" "ConfigMap" .scope.Release.Namespace .name) | default dict }}
  {{- $configData := (get $configObj "data") | default dict }}
  {{- range $key, $value := .params }}
  {{- $configValue := (get $configData $key) | default ($value)}}
  {{ $key }}: {{ $configValue | quote }}
  {{- end }}
{{- end -}}

{{/*
OC chown init data command
*/}}
{{- define "oc.initChownDataCommand" -}}
command: ["chown", {{ ne .Values.securityContext.fsGroupChangePolicy "OnRootMismatch" | ternary "\"-R\", " "" }}"{{ .Values.securityContext.runAsUser }}:{{ .Values.securityContext.runAsGroup }}", "/var/lib/opencloud"]
{{- end -}}
