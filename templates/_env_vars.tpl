{{- define "gitlab-runner.runner-env-vars" }}
{{- if .Values.envVars -}}
{{ range .Values.envVars }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}
{{- end }}
{{- end }}
