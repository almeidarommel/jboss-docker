FROM registry.access.redhat.com/ubi8/ubi

ENV JBOSS_HOME=/usr/jboss \
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

RUN unzip jboss-eap-6.4.0.zip -d ${JBOSS_HOME}

RUN cp jboss-eap-6.4/* -R ${JBOSS_HOME}/.

EXPOSE 80 443 9090 9990

RUN chown ${JBOSS_USER}.${JBOSS_GROUP} ${JBOSS_HOME} -R

USER ${JBOSS_USER}

RUN ./bin/add-user.sh admin Admin.123# --silent