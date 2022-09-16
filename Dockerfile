FROM image-registry.openshift-image-registry.svc:5000/jboss-hello-world/jboss-eap64-openshift
ENV LANG="en_US.UTF-8"
#USER root

WORKDIR ${JBOSS_HOME} 

#RUN yum install -y zip && \
#    groupadd  ${JBOSS_GROUP} && \ 
#    adduser ${JBOSS_USER} -G ${JBOSS_GROUP} && \ 
#     chown ${JBOSS_USER}.${JBOSS_GROUP} ${JBOSS_HOME} -R 
#

COPY --chown=jboss:root --from=compile ${JBOSS_HOME}/extensions.cli  ${JBOSS_HOME}/extensions/
# Quebra de linha: ${JBOSS_HOME}/datasource-helloworld-ws.cli ${JBOSS_HOME}/extensions/
COPY --chown=jboss:root --from=compile helloworld-ws.war ${JBOSS_HOME}/deployments/

EXPOSE 80 443 9090 9990
