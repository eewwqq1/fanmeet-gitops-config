{{/*
Each of the 4 deployment units gets its own Helm release (e.g. `helm install fanmeet-server
charts/service -f values-server.yaml`), so the release name alone is a unique, human-readable
identity — no need to also fold in the chart name.
*/}}
{{- define "service.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "service.labels" -}}
app.kubernetes.io/name: {{ include "service.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "service.fullname" . }}
{{- end -}}
