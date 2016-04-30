FROM centos:latest

MAINTAINER Sami Kallio phinaliumz at outlook.com

RUN yum update -y && yum install wget unzip -y \   
&& wget http://download.jboss.org/wildfly/9.0.1.Final/wildfly-9.0.1.Final.tar.gz && tar -C /opt/ -xzf wildfly-9.0.1.Final.tar.gz \ 
&& mv /opt/wildfly-9.0.1.Final /opt/wildfly && rm --force wildfly-9.0.1.Final.tar.gz \  
&& yum install java-1.7.0-openjdk -y && yum clean all -y && cd /opt/wildfly/ \   
&& wget http://downloads.jboss.org/modeshape/4.6.0.Final/modeshape-4.6.0.Final-jboss-wf9-dist.zip \ 
&& unzip modeshape-4.6.0.Final-jboss-wf9-dist.zip && rm --force modeshape-4.6.0.Final-jboss-wf9-dist.zip \ 
&& sed '/<webapp name=\"modeshape-rest.war\"\/>/i <!--' standalone/configuration/standalone-modeshape.xml > standalone/configuration/standalone-modeshape-new.xml \ 
&& sed '/<webapp name=\"modeshape-explorer.war\"\/>/a -->' standalone/configuration/standalone-modeshape-new.xml > standalone/configuration/standalone-modeshape.xml && sed -i.bkp '/<http-listener name=\"default\" socket-binding=\"http\" redirect-socket=\"https\"\/>/a <ajp-listener name=\"ajp\" socket-binding=\"ajp\"\/>' standalone/configuration/standalone-modeshape.xml \  
&& rm --force standalone/configuration/standalone-modeshape-new.xml \ 
&& echo "admin=readwrite,read,admin" >> standalone/configuration/application-roles.properties \ 
&& wget -O /tmp/postgresql-9.4.1208.jre7.jar https://jdbc.postgresql.org/download/postgresql-9.4.1208.jre7.jar 
ADD batchfiles/config.sh /tmp/
ADD datasource.cli /tmp/
RUN /tmp/config.sh  
ADD runcommands.sh /opt/

EXPOSE 8009

CMD sh /opt/runcommands.sh 

