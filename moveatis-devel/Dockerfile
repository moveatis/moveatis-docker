FROM centos:latest

MAINTAINER Sami Kallio phinaliumz at outlook.com

RUN yum update -y && yum install wget unzip -y \   
&& wget http://download.jboss.org/wildfly/10.0.0.Final/wildfly-10.0.0.Final.tar.gz && tar -C /opt/ -xzf wildfly-10.0.0.Final.tar.gz \ 
&& mv /opt/wildfly-10.0.0.Final /opt/wildfly && rm --force wildfly-10.0.0.Final.tar.gz 
RUN yum install java-1.8.0-openjdk -y && yum clean all -y && cd /opt/wildfly/ \    
&& echo "admin=readwrite,read,admin" >> standalone/configuration/application-roles.properties \ 
&& wget -O /tmp/postgresql-9.4.1208.jar https://jdbc.postgresql.org/download/postgresql-9.4.1208.jar
ADD config/standalone.xml /tmp/ 
ADD batchfiles/config.sh /tmp/
ADD datasource.cli /tmp/
RUN /tmp/config.sh  
ADD runcommands.sh /opt/

EXPOSE 8080 8787 9990 

CMD sh /opt/runcommands.sh 

