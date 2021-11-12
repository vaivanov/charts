{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gradle-build-cache-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gradle-build-cache-node.fullname" -}}
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
{{- define "gradle-build-cache-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get KubeVersion removing pre-release information.
*/}}
{{- define "gradle-build-cache-node.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version (regexFind "v[0-9]+\\.[0-9]+\\.[0-9]+" .Capabilities.KubeVersion.Version) -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "gradle-build-cache-node.ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19.x" (include "gradle-build-cache-node.kubeVersion" .)) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "gradle-build-cache-node.ingress.isStable" -}}
  {{- eq (include "gradle-build-cache-node.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "gradle-build-cache-node.ingress.supportsIngressClassName" -}}
  {{- or (eq (include "gradle-build-cache-node.ingress.isStable" .) "true") (and (eq (include "gradle-build-cache-node.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "gradle-build-cache-node.kubeVersion" .))) -}}
{{- end -}}

{{/*
Return if ingress supports pathType.
*/}}
{{- define "gradle-build-cache-node.ingress.supportsPathType" -}}
  {{- or (eq (include "gradle-build-cache-node.ingress.isStable" .) "true") (and (eq (include "gradle-build-cache-node.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "gradle-build-cache-node.kubeVersion" .))) -}}
{{- end -}}
