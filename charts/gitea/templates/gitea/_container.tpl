{{/*
Create helm partial for gitea server
*/}}
{{- define "gitea" }}
- name: gitea
  image: {{ .Values.images.gitea }}
  imagePullPolicy: {{ .Values.images.imagePullPolicy }}
  env:
  - name: POSTGRES_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ template "db.fullname" . }}
        key: dbPassword
  - name: GITEA_CUSTOM
    value: /etc/gitea
  ports:
  - name: ssh
    containerPort: {{ .Values.service.ssh.port  }}
  - name: http
    containerPort: {{ .Values.service.https.targetPort  }}
  livenessProbe:
    tcpSocket:
      port: http
    initialDelaySeconds: 200
    timeoutSeconds: 1
    periodSeconds: 10
    successThreshold: 1
    failureThreshold: 10
  readinessProbe:
    tcpSocket:
      port: http
    initialDelaySeconds: 5
    periodSeconds: 10
    successThreshold: 1
    failureThreshold: 3
  resources:
{{ toYaml .Values.resources.gitea | indent 10 }}
  volumeMounts:
  - name: gitea-data
    mountPath: /data
  - name: gitea-data
    mountPath: /etc/gitea
  - name: gitea-certs
    mountPath: /etc/certs
{{- end }}