{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pghero.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pghero.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "pghero.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pghero.labels" -}}
app: {{ include "pghero.name" . }}
chart: {{ include "pghero.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}


{{/*
Get the database url secret.
*/}}
{{- define "pghero.secretName" -}}
{{- if .Values.existingSecret -}}
{{- printf "%s" .Values.existingSecret -}}
{{- else -}}
{{- printf "%s" (include "pghero.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password key to be retrieved from pghero secret.
*/}}
{{- define "pghero.existingSecretKey" -}}
{{- if and .Values.existingSecret .Values.existingSecretKey -}}
{{- printf "%s" .Values.existingSecretKey -}}
{{- else -}}
{{- printf "pghero-database-url" -}}
{{- end -}}
{{- end -}}


{{/*
Return the database url
*/}}
{{- define "pghero.databaseUrl" -}}
{{- if not (empty .Values.databaseUrl) -}}
    {{- .Values.databaseUrl -}}
{{- end -}}
{{- end -}}
