FROM registry.redhat.io/redhat-openjdk-18/openjdk18-openshift:latest
USER root
COPY boot-app-1.0-SNAPSHOT.jar /opt/app-root/boot-app.jar
COPY appdynamics /opt/appdyn/
# SET Environment variables
ENV APPD_HOST=sd-eb4b-fcaa.nam.nsroot.net \
 APPD_PORT=8181 \
 APPD_APPNAME=149931_GCBPOC_NAM_DEV \
 APPD_TIERNAME=HelloWorld-ECS \
 APPD_ACCESSKEY=4easdfasdf-4d47adf-414adf3-8fasdf377-27aa6d842ffffake \
 APPD_NODENAME_PREFIX=HelloWorld
### Changing ownership and permission for AppDynamics installation directory
RUN chown -R 1001:0 /opt/appdyn && \
 find /opt/appdyn -exec chgrp 0 {} \; && \
 find /opt/appdyn -exec chmod g+rw {} \; && \
 find /opt/appdyn -type d -exec chmod g+x {} +
USER 1001
CMD java -javaagent:/opt/appdyn/javaagent.jar -Dappdynamics.controller.hostName=${APPD_HOST} -Dappdynamics.controller.port=${APPD_PORT} \
-Dappdynamics.agent.applicationName=${APPD_APPNAME} -Dappdynamics.agent.tierName=${APPD_TIERNAME} -Dappdynamics.agent.reuse.nodeName=true \
-Dappdynamics.agent.reuse.nodeName.prefix=${APPD_NODENAME_PREFIX} -Dappdynamics.agent.uniqueHostId=$(sed -rn'1s#.*/##; 1s/docker-(.{12}).*/\1/p' /proc/self/cgroup) \
-Dappdynamics.controller.ssl.enabled=true -Dappdynamics.agent.accountAccessKey=${APPD_ACCESSKEY} -jar /opt/app-root/boot-app.jar
