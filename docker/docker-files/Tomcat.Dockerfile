FROM python:3.9.6
ENV CATALINA_BASE=/usr/share/tomcat
ENV CATALINA_HOME=/usr/share/tomcat
ENV CATALINA_TMPDIR=/usr/share/tomcat/temp
ENV JRE_HOME=/usr/lib/jvm/java-8-oracle
ENV CLASSPATH=/usr/share/tomcat/bin/bootstrap.jar:/usr/share/tomcat/bin/tomcat-juli.jar
ENV CATALINA_OPTS=

RUN mkdir -p /root/tmp
WORKDIR /root/tmp

RUN apt-get update && apt-get upgrade -y

RUN apt install -y apt-transport-https ca-certificates wget dirmngr gnupg
RUN apt install -y software-properties-common openssh-server sudo


RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN sudo apt-get update && apt-get install -y adoptopenjdk-8-hotspot


RUN adduser --system --shell /bin/bash --gecos 'Tomcat Java Servlet and JSP engine' \
   --group --disabled-password --home /home/tomcat tomcat

RUN wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.70/bin/apache-tomcat-8.5.70.tar.gz
RUN tar xvzf ./apache-tomcat-8.5.70.tar.gz
RUN rm -f apache-tomcat-8.5.70.tar.gz
RUN rm -rf /usr/share/tomcat
RUN mv /root/tmp/apache-tomcat-8.5.70 /usr/share/tomcat
# RUN ln -s /usr/share/apache-tomcat-8.5.70 /usr/share/tomcat

RUN chown -R tomcat:tomcat /usr/share/tomcat/*
RUN chmod +x /usr/share/tomcat/bin/*.sh

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -g tomcat -G sudo -u 1000 caltech 
RUN  echo 'caltech:caltech' | chpasswd
COPY ./conf/tomcat/sudoers /etc/

RUN ls /usr/share/tomcat/webapps -al
COPY ./conf/tomcat/project01.war /root/tmp/project01.war
RUN mv /root/tmp/project01.war /usr/share/tomcat/webapps
RUN ls /usr/share/tomcat/webapps -al

RUN rm -f /usr/share/tomcat/conf/tomcat-users.xml
COPY ./conf/tomcat/tomcat-users.xml /usr/share/tomcat/conf

RUN rm -f /usr/share/tomcat/conf/context.xml
COPY ./conf/tomcat/context.xml /usr/share/tomcat/conf

COPY ./conf/tomcat/start-tomcat.sh /start-tomcat.sh
RUN chmod +x /start-tomcat.sh

WORKDIR /usr/share/tomcat

EXPOSE 8080
EXPOSE 22

ENTRYPOINT [ "/start-tomcat.sh" ]
