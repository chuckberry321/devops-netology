FROM amazoncorretto

ADD https://pkg.jenkins.io/redhat-stable/jenkins.repo /etc/yum.repos.d/

RUN amazon-linux-extras install epel -y && \
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key && \
    yum install -y jenkins

EXPOSE 8080

CMD ["java", "-jar", "/usr/lib/jenkins/jenkins.war"]
