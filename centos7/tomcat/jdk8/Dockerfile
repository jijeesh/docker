FROM centos:latest
MAINTAINER silentheartbeat@gmail.com

# Install prepare infrastructure
RUN yum -y update && \
	yum -y install wget && \
	yum -y install tar 

# Prepare environment 
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Oracle Java8
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz"
RUN tar xzf jdk-8u101-linux-x64.tar.gz 
RUN rm jdk*.tar.gz 
RUN mv jdk* ${JAVA_HOME}


# Install Tomcat
RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.38/bin/apache-tomcat-8.0.38.tar.gz && \
	tar -xvf apache-tomcat-8.0.38.tar.gz && \
	rm apache-tomcat*.tar.gz && \
	mv apache-tomcat* ${CATALINA_HOME} 
COPY server.xml ${CATALINA_HOME}/conf/server.xml
RUN chmod +x ${CATALINA_HOME}/bin/*sh
RUN rm -rf ${CATALINA_HOME}/webapps/*
RUN mkdir /root/.aws
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf "\n\
java.util.logging.FileHandler.level = FINE \n\
java.util.logging.FileHandler.formatter = java.util.logging.SimpleFormatter \n\
java.util.logging.FileHandler.pattern = ${CATALINA_HOME}/logs/catalina.%g.log \n\
java.util.logging.FileHandler.limit = 10000 \n\
java.util.logging.FileHandler.count = 15 \n\
\n" \
 >> ${CATALINA_HOME}/conf/logging.properties
RUN sed -i \
	-e 's/^handlers = .*/handlers = java.util.logging.FileHandler, 1catalina.org.apache.juli.AsyncFileHandler, 2localhost.org.apache.juli.AsyncFileHandler, 3manager.org.apache.juli.AsyncFileHandler, 4host-manager.org.apache.juli.AsyncFileHandler, java.util.logging.ConsoleHandler/1' \
	${CATALINA_HOME}/conf/logging.properties
EXPOSE 8080
CMD ["catalina.sh", "run"]


