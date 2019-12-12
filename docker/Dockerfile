# Default Centos7 with Java installed for tomcat
FROM centos:centos7

# Givs us the ability to define version
ENV TOMCATVER 7.0.93

# Get minimal tools to work
RUN yum install -y \
                    wget \
                    tar \
                    java-1.7.0-openjdk-devel; \
groupadd tomcat; \
useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat; \
wget https://www-eu.apache.org/dist/tomcat/tomcat-7/v${TOMCATVER}/bin/apache-tomcat-${TOMCATVER}.tar.gz; \
mkdir /opt/tomcat; \
tar xvf apache-tomcat-${TOMCATVER}.tar.gz -C /opt/tomcat --strip-components=1; \
#mv /opt/apache-tomcat* /opt/tomcat; \
#rm /opt/apache-tomcat-${TOMCATVER}.tar.gz; \
cd /opt/tomcat; \
chgrp -R tomcat /opt/tomcat; \
chmod -R g+r conf; \
chmod g+x conf; \
chown -R tomcat webapps/ work/ temp/ logs/

COPY conf/tomcat.service /etc/systemd/system/tomcat.service
COPY conf/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
#COPY conf/HelloWorld-Time.war /opt/tomcat/webapps/
#RUN /opt/tomcat/bin/startup.sh

ENV PATH /opt/tomcat/bin:$PATH
#HEALTHCHECK --interval=10s --timeout=10s --retries=3 CMD curl -f  http://localhost:8080/HelloWorld-Time || exit 1

# Expose the default port
EXPOSE 8080

CMD ["catalina.sh", "run"]