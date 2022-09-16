FROM image-registry.openshift-image-registry.svc:5000/teste/image:latest as compile
WORKDIR /opt/eap-app
COPY . /opt/eap-app
RUN mvn install  


FROM image-registry.openshift-image-registry.svc:5000/teste/image-jb:latest
ENV LANG="en_US.UTF-8"
USER root
COPY --chown=jboss:root --from=compile /opt/eap-app/extensions.cli /opt/eap/extensions/
COPY --chown=jboss:root --from=compile /opt/eap-app/receita-rest/target/hello-world /deployments/