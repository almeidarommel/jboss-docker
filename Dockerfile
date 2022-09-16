FROM registry.access.redhat.com/ubi8/openjdk-11  
ENV LANG="en_US.UTF-8"
USER root

MAINTAINER Rommel Almeida <rpinto@redhat.com>

ENV     JBOSS_HOME=/usr/jboss \
    JBOSS_GROUP=web \
    JBOSS_USER=jboss

RUN mkdir -p ${JBOSS_HOME}

WORKDIR ${JBOSS_HOME} 

COPY  jboss-eap-6.4.0.zip ${JBOSS_HOME}/.

RUN yum install -y java-1.8.0-openjdk.x86_64 && \
    yum install -y zip && \
    groupadd  ${JBOSS_GROUP} && \ 
    adduser ${JBOSS_USER} -G ${JBOSS_GROUP} && \ 
     chown ${JBOSS_USER}.${JBOSS_GROUP} ${JBOSS_HOME} -R 

RUN unzip jboss-eap-6.3.0.zip -d ${JBOSS_HOME}

RUN cp jboss-eap-7.3/* -R ${JBOSS_HOME}/.

COPY --chown=jboss:root --from=compile ${JBOSS_HOME}/extensions.cli ${JBOSS_HOME}/datasource-helloworld-ws.cli ${JBOSS_HOME}/extensions/

COPY --chown=jboss:root --from=compile helloworld-ws.war ${JBOSS_HOME}/deployments/

EXPOSE 80 443 9090 9990

RUN chown ${JBOSS_USER}.${JBOSS_GROUP} ${JBOSS_HOME} -R

USER ${JBOSS_USER}

RUN ./bin/add-user.sh admin Admin.123# --silent

CMD ["./bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
