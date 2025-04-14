{{/*
Renvoie le nom du chart (ou la valeur surchargée par .Values.nameOverride s'il est défini).
*/}}
{{- define "jenkins-devops-exams.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Renvoie le nom complet (fully qualified name) en combinant le nom de release et le nom du chart.
*/}}
{{- define "jenkins-devops-exams.fullname" -}}
  {{- printf "%s-%s" .Release.Name (include "jenkins-devops-exams.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Renvoie le nom du ServiceAccount.
Utilise .Values.serviceAccount.name s'il est défini, sinon génère un nom complet.
*/}}
{{- define "jenkins-devops-exams.serviceAccountName" -}}
  {{- if .Values.serviceAccount.name -}}
    {{- .Values.serviceAccount.name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{ include "jenkins-devops-exams.fullname" . }}
  {{- end -}}
{{- end -}}

{{/*
Renvoie un ensemble de labels par défaut pour vos ressources.
*/}}
{{- define "jenkins-devops-exams.labels" -}}
app.kubernetes.io/name: {{ include "jenkins-devops-exams.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Renvoie les labels utilisés pour le selector des pods.
*/}}
{{- define "jenkins-devops-exams.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jenkins-devops-exams.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Aliases pour compatibilité avec vos templates existants appelant fastapiapp.* */}}

{{- define "fastapiapp.serviceAccountName" -}}
  {{ include "jenkins-devops-exams.serviceAccountName" . }}
{{- end -}}

{{- define "fastapiapp.labels" -}}
  {{ include "jenkins-devops-exams.labels" . }}
{{- end -}}

{{- define "fastapiapp.name" -}}
  {{ include "jenkins-devops-exams.name" . }}
{{- end -}}

{{- define "fastapiapp.fullname" -}}
  {{ include "jenkins-devops-exams.fullname" . }}
{{- end -}}

{{- define "fastapiapp.selectorLabels" -}}
  {{ include "jenkins-devops-exams.selectorLabels" . }}
{{- end -}}
