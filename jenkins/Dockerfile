FROM jenkins/jenkins:2.289.3-lts-jdk11
ARG GID
ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable" && \
   addgroup --gid ${GID} docker && \
   apt-get update && apt-get install -y docker-ce && \
   rm -rf /var/lib/apt/lists/* && \
   usermod -aG docker jenkins
USER jenkins
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
RUN jenkins-plugin-cli --plugins "git:4.8.1 matrix-auth:2.6.8 workflow-job:2.41 workflow-cps:2.93 workflow-aggregator:2.6 docker-workflow:1.26"
