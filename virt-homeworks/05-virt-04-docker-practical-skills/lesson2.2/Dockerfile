FROM ubuntu:latest

ADD https://pkg.jenkins.io/debian-stable/jenkins.io.key /tmp/

RUN apt-get update && \
    apt-get install -y gnupg ca-certificates && \
    apt-key add /tmp/jenkins.io.key && \
    sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list' && \
    apt-get update && \
    apt install -y default-jre && \
    apt-get install -y jenkins

EXPOSE 8080

CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
