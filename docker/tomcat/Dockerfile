# Default Centos7 with Java installed for tomcat
FROM tomcat

# Givs us the ability to define version


# Get minimal tools to work
#RUN yum install -y wget 
# tar curl; \
#                    java-1.7.0-openjdk-devel \
COPY conf/tomcat.service /etc/systemd/system/tomcat.service
COPY conf/tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY conf/HelloWorld-Time.war /usr/local/tomcat/webapps/
COPY conf/Petclinic.war /usr/local/tomcat/webapps/
#RUN wget --no-check-certificate --no-proxy 'https://provision-cf-tf.s3.amazonaws.com/application/Petclinic.war'
###groupadd tomcat; \
###useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat; \
#useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat; \
###curl -O --progress-bar http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz; \
#wget https://www-eu.apache.org/dist/tomcat/tomcat-7/v${TOMCATVER}/bin/apache-tomcat-${TOMCATVER}.tar.gz; \
###mkdir /opt/tomcat; \
###tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1; \
#tar xvf apache-tomcat-${TOMCATVER}.tar.gz -C /opt/tomcat --strip-components=1; \
#mv /opt/apache-tomcat* /opt/tomcat; \
#rm /opt/apache-tomcat-${TOMCATVER}.tar.gz; \
# Assign ownership over target directory
###cd /opt/tomcat; \
###chgrp -R tomcat /opt/tomcat; \
###chmod -R g+r /opt/tomcat/conf; \
###chmod g+x /opt/tomcat/conf; \
###chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/

#RUN /opt/tomcat/bin/startup.sh

###ENV PATH /opt/tomcat/bin:$PATH
#RUN systemctl daemon-reload; \
#systemctl start tomcat; \
#systemctl status tomcat; \
#HEALTHCHECK --interval=10s --timeout=10s --retries=3 CMD curl -f  http://localhost:8080/HelloWorld-Time || exit 1

# Expose the default port
EXPOSE 8080
#ENV /usr/local/tomcat/bin/catalina.sh
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]