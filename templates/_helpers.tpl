{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gitlab-runner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gitlab-runner.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the secret containing the tokens
*/}}
{{- define "gitlab-runner.secret.name" -}}
{{- default (include "gitlab-runner.fullname" .) .Values.runners.secret | quote -}}
{{- end -}}

{{/*
Define the key of the secret containing the runner-registration-token
*/}}
{{- define "gitlab-runner.secret.runnerRegistrationTokenKey" -}}
{{- default "runner-registration-token" .Values.runners.runnerRegistrationTokenKey | quote -}}
{{- end -}}

{{/*
Define the key of the secret containing the runner-token
*/}}
{{- define "gitlab-runner.secret.runnerTokenKey" -}}
{{- default "runner-token" .Values.runners.runnerTokenKey | quote -}}
{{- end -}}

{{/*
Define the name of the s3 cache secret
*/}}
{{- define "gitlab-runner.cache.secret.name" -}}
{{- default "s3access" .Values.runners.cache.secretName | quote -}}
{{- end -}}

{{/*
Define the key of the s3 cache secret containing access key
*/}}
{{- define "gitlab-runner.cache.secret.accessKey" -}}
{{- default "accesskey" .Values.runners.cache.accessKey | quote -}}
{{- end -}}

{{/*
Define the key of the s3 cache secret containing secret key
*/}}
{{- define "gitlab-runner.cache.secret.secretKey" -}}
{{- default "secretkey" .Values.runners.cache.secretKey | quote -}}
{{- end -}}

{{/*
Template for outputing the gitlabUrl
*/}}
{{- define "gitlab-runner.gitlabUrl" -}}
{{- .Values.gitlabUrl | quote -}}
{{- end -}}

{{/*
Template runners.cache.s3ServerAddress in order to allow overrides from external charts.
*/}}
{{- define "gitlab-runner.cache.s3ServerAddress" }}
{{- default "" .Values.runners.cache.s3ServerAddress | quote -}}
{{- end -}}
