## Configurando uma imagem JBoss personalizada

### Criar um Dockerfile
```
vim Dockerfile 
```
Content:
```
FROM registry.access.redhat.com/ubi8/ubi

ENV JBOSS_HOME=/usr/jboss \
	JBOSS_GROUP=web 
#	JBOSS_USER=root


RUN mkdir -p ${JBOSS_HOME}

WORKDIR ${JBOSS_HOME} 

COPY  jboss-eap-6.4.0.zip ${JBOSS_HOME}/.

RUN yum install -y java-1.8.0-openjdk.x86_64 && \
	yum install -y zip 
#	groupadd  ${JBOSS_GROUP} && \ 
#    	adduser ${JBOSS_USER} -G ${JBOSS_GROUP} && \ 
#    	chown ${JBOSS_USER}.${JBOSS_GROUP} ${JBOSS_HOME} -R 

RUN unzip jboss-eap-6.4.0.zip -d ${JBOSS_HOME}

RUN cp jboss-eap-6.4/* -R ${JBOSS_HOME}/.

RUN rm jboss-eap-6.4.0.zip

EXPOSE 80 443 9090 9990

# RUN chown ${JBOSS_USER}.${JBOSS_GROUP} ${JBOSS_HOME} -R

RUN ./bin/add-user.sh admin Admin.123# --silent

CMD ["./bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
```

### Buildar o Dockerfile
```
sudo podman build -t eap64-image .
```

### Criar repositório no Dockerhub

Acessar o console do dockerHub e realizar o procedimento

### Fazer o login do Openshift ao Dockerhub
```
sudo podman login docker.io
username: user1
password: senha
```
### Realizar tag da imagem:
Ex: sudo podman tag <imagem_origem> <imagem_destino>
```
sudo podman tag localhost/eap64-image  almeidarommel/jboss64:1.2
```
### Realizar o push da imagem para Docker hub
Ex: sudo podman push <repositório>/<nome_da_imagem>:<tag>
```
sudo podman push almeidarommel/jboss64:1.2
```
<Repositório DockerHub><https://hub.docker.com/repository/docker/almeidarommel/jboss64/general>

### Realizar o import-image para o Openshift
Ex: oc import-image <image>:<tag> --from=<repositório>/<image>:<tag> --confirm
```
oc import-image jboss64:1.2 --from=almeidarommel/jboss64:1.2 --confirm
```
### Adicionar as permissões necessárias para subir o DeploymentConfig e resolver erros de permission Denied: (Lembrando que você deve ser cluster-admin)
Ex: oc adm policy add-scc-to-user anyuid -z default -n <namespace>
```
oc adm policy add-scc-to-user anyuid -z default -n jboss-hello-world
```

### Realizar o DeploymentConfig no Openshift

Criar o DeploymentConfig e add o seguinte conteúdo:

```
kind: DeploymentConfig
apiVersion: apps.openshift.io/v1
metadata:
  name: helloworld-ws
  namespace: jboss-hello-world
  uid: bf9ee223-25db-46c2-9a25-ae37bd780621
  resourceVersion: '2401654'
  generation: 14
  creationTimestamp: '2022-09-16T19:50:46Z'
  labels:
    app: helloworld-ws
spec:
  strategy:
    type: Rolling
    rollingParams:
      updatePeriodSeconds: 1
      intervalSeconds: 1
      timeoutSeconds: 600
      maxUnavailable: 25%
      maxSurge: 25%
    resources: {}
    activeDeadlineSeconds: 21600
  triggers:
    - type: ConfigChange
  replicas: 1
  revisionHistoryLimit: 10
  test: false
  selector:
    app: helloworld-ws
    deploymentconfig: helloworld-ws
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: helloworld-ws
        deploymentconfig: helloworld-ws
    spec:
      containers:
        - name: helloworld-ws
          image: >-
            image-registry.openshift-image-registry.svc:5000/jboss-hello-world/jboss64:1.2
          ports:
            - containerPort: 80
              protocol: TCP
            - containerPort: 443
              protocol: TCP
            - containerPort: 9090
              protocol: TCP
            - containerPort: 9990
              protocol: TCP
          env:
            - name: TP_AMBIENTE
              value: dese
            - name: DB_DDL_AUTO
              value: none
            - name: TZ
              value: America/Fortaleza
            - name: http_proxy
              value: '10.15.15.36:9191'
            - name: https_proxy
              value: '10.15.15.36:9191'
            - name: DISABLE_EMBEDDED_JMS_BROKER
              value: 'true'
            - name: http.proxyHost
              value: 10.15.15.36
            - name: http.proxyPort
              value: '9090'
            - name: http.proxyHost
              value: 10.15.15.36
            - name: http.proxyPort
              value: '9090'
            - name: URL_SMTP
              value: '10.15.15.36'
            - name: EMAIL_REMETENTE
              value: naoresponda@teste.com.br
          resources: {}
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          imagePullPolicy: Always
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
      dnsPolicy: ClusterFirst
      securityContext: {}
      schedulerName: default-scheduler
```

## Configurar um service
```
asdasda
```

## Configurar uma route
```
EX: oc expose svc/name_service 
```
## Realizar o teste da aplicação
https://<domain_ocp>/route/<context>
https://<domain_ocp>/route/jboss-helloworld-ws/HelloWorldService?wsdl


