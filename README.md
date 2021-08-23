# deployment-using-ansible-cm-tool
CalTech - SimpliLearn - Configuration Management - Project 01: CI/CD Deployment Using Ansible CM Tool 

<br />

Because the focus of this project is to update an application using Ansible, the source code highlighted below is only that which makes the remote update possible. To view the entire source please clone the repository using `git clone https://github.com/bbrown-caltech/deployment-using-ansible-cm-tool.git`.

<br />

## Source Code

<br />

### Maven Configuration

#### project01/pom.xml

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.simplilearn.cm</groupId>
  <artifactId>project01</artifactId>
  <packaging>war</packaging>
  <version>2.0-SNAPSHOT</version>
  <name>project01</name>
  <url>http://maven.apache.org</url>
  <properties>
     <maven.compiler.source>1.8</maven.compiler.source>
     <maven.compiler.target>1.8</maven.compiler.target>
     <nexus.group.url>http://localhost:8081/repository/maven-group/</nexus.group.url>
     <nexus.snapshots.url>http://localhost:8081/repository/maven-snapshots/</nexus.snapshots.url>
     <nexus.release.url>http://localhost:8081/repository/maven-releases/</nexus.release.url>
  </properties>
  <dependencies>
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>servlet-api</artifactId>
      <version>2.5</version>
    </dependency>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <pluginManagement>
      <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-jar-plugin</artifactId>
          <version>2.4</version>
          <configuration>
            <finalName>${project.artifactId}-${project.version}.war</finalName>
          </configuration>
        </plugin>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-war-plugin</artifactId>
          <version>2.4</version>
          <configuration>
            <finalName>${project.artifactId}-${project.version}.war</finalName>
          </configuration>
        </plugin>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-source-plugin</artifactId>
          <version>2.1.2</version>
        </plugin>
        <plugin>
          <groupId>org.sonatype.plugins</groupId>
          <artifactId>nexus-staging-maven-plugin</artifactId>
          <version>1.5.1</version>
          <executions>
              <execution>
                <id>default-deploy</id>
                <phase>deploy</phase>
                <goals>
                    <goal>deploy</goal>
                </goals>
              </execution>
          </executions>
          <configuration>
              <serverId>nexus</serverId>
              <nexusUrl>${nexus.group.url}</nexusUrl>
              <skipStaging>true</skipStaging>
          </configuration>
        </plugin>
      </plugins>
    </pluginManagement>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <configuration>
          <archive>
            <addMavenDescriptor>false</addMavenDescriptor>
          </archive>
        </configuration>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-war-plugin</artifactId>
        <configuration>
          <archive>
            <addMavenDescriptor>false</addMavenDescriptor>
          </archive>
        </configuration>
      </plugin>
    </plugins>
  </build>
  <repositories>
    <repository>
      <snapshots>
        <enabled>false</enabled>
      </snapshots>
      <id>central</id>
      <name>bintray</name>
      <url>https://jcenter.bintray.com</url>
    </repository>
    <repository>
      <id>maven-group</id>
      <url>${nexus.group.url}</url>
    </repository>
  </repositories>
  <distributionManagement>
    <snapshotRepository>
      <id>nexus-snapshots</id>
      <uniqueVersion>false</uniqueVersion>
      <url>${nexus.snapshots.url}</url>
    </snapshotRepository>
    <repository>
      <id>nexus-releases</id>
      <url>${nexus.release.url}</url>
    </repository>
  </distributionManagement>
</project>

```

<br />

#### docker/conf/.m2/settings.xml

```xml
<settings>

  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>caltech</username>
      <password>Password123</password>
    </server>
    <server>
      <id>nexus-releases</id>
      <username>caltech</username>
      <password>Password123</password>
    </server>
  </servers>
  
  <mirrors>
    <mirror>
      <!--This sends everything else to /public -->
      <id>nexus</id>
      <mirrorOf>*</mirrorOf>
      <url>http://nexus:8081/repository/maven-group/</url>
    </mirror>
  </mirrors>
  <profiles>
    <profile>
      <id>nexus</id>
      <!--Enable snapshots for the built in central repo to direct -->
      <!--all requests to nexus via the mirror -->
      <repositories>
        <repository>
          <id>central</id>
          <url>http://central</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </repository>
      </repositories>
     <pluginRepositories>
        <pluginRepository>
          <id>central</id>
          <url>http://central</url>
          <releases><enabled>true</enabled></releases>
          <snapshots><enabled>true</enabled></snapshots>
        </pluginRepository>
      </pluginRepositories>
    </profile>
  </profiles>
  <activeProfiles>
    <!--make the profile active all the time -->
    <activeProfile>nexus</activeProfile>
  </activeProfiles>
</settings>

```

<br />

### Tomcat Server

#### docker/docker-files/Tomcat.Dockerfile

Used to create an image containing both the Apache Tomcat server for hosting our WAR file. It also installs OpenSSH-Server so that Ansible can connect and update the application.

```dockerfile
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

```

<br />

#### docker/conf/tomcat/context.xml

```xml
<?xml version='1.0' encoding='utf-8'?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!-- The contents of this file will be loaded for each web application -->
<Context reloadable="true">

    <!-- Default set of monitored resources. If one of these changes, the    -->
    <!-- web application will be reloaded.                                   -->
    <WatchedResource>WEB-INF/web.xml</WatchedResource>
    <WatchedResource>${catalina.base}/conf/web.xml</WatchedResource>
    <Resources antiResourceLocking="false" cachingAllowed="false" />
    
    <!-- Uncomment this to disable session persistence across Tomcat restarts -->
    <!--
    <Manager pathname="" />
    -->

    <!-- Uncomment this to enable Comet connection tacking (provides events
         on session expiration as well as webapp lifecycle) -->
    <!--
    <Valve className="org.apache.catalina.valves.CometConnectionManagerValve" />
    -->
</Context>

```

<br />

#### docker/conf/tomcat/tomcat-users.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users>
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <role rolename="admin-gui"/>
  <role rolename="admin-script"/>
  <user username="admin" password="admin" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>
</tomcat-users>

```

<br />

#### docker/conf/tomcat/start-tomcat.sh

```bash
#!/bin/bash

# Start Tomcat
/bin/su - tomcat -c /usr/share/tomcat/bin/startup.sh

rm -rf /run/sshd
mkdir -p /run/sshd

# Start OpenSSH Server
/usr/sbin/sshd -D

```

<br />

### Ansible

#### docker/docker-files/Ansible.Dockerfile

Used for creating the Ansible server used to push updates to our Tomcat application server.

```Dockerfile
FROM python:3.9.6

RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt update && apt upgrade -y
RUN apt install -y ansible openssh-server sudo git sshpass

RUN useradd -rm -d /home/debian -s /bin/bash -g root -G sudo -u 1000 caltech 

RUN  echo 'caltech:caltech' | chpasswd

RUN mkdir -p /playbooks

COPY ./conf/ansible/playbooks /playbooks/
COPY ./conf/ansible/ansible.hosts /etc/ansible/hosts
COPY ./conf/ansible/ansible.cfg /etc/ansible/ansible.cfg

RUN service ssh start

EXPOSE 22

CMD /usr/sbin/sshd -D

```

<br />

#### docker/conf/ansible/ansible.cfg

```code
[defaults]
host_key_checking = false

```

<br />

#### docker/conf/ansible/ansible.hosts

```code
# This is the default ansible 'hosts' file.
#
# It should live in /etc/ansible/hosts
#
#   - Comments begin with the '#' character
#   - Blank lines are ignored
#   - Groups of hosts are delimited by [header] elements
#   - You can enter hostnames or ip addresses
#   - A hostname/ip can be a member of multiple groups

# Ex 1: Ungrouped hosts, specify before any group headers.

#green.example.com
#blue.example.com
#192.168.100.1
#192.168.100.10

# Ex 2: A collection of hosts belonging to the 'webservers' group

#[webservers]
#alpha.example.org
#beta.example.org
#192.168.1.100
#192.168.1.110

# If you have multiple hosts following a pattern you can specify
# them like this:

#www[001:006].example.com

# Ex 3: A collection of database servers in the 'dbservers' group

#[dbservers]
#
#db01.intranet.mydomain.net
#db02.intranet.mydomain.net
#10.25.1.56
#10.25.1.57

# Here's another example of host ranges, this time there are no
# leading 0s:

#db-[99:101]-node.example.com

[caltech]
tomcat ansible_user=caltech ansible_ssh_pass=caltech

```

<br />

#### docker/conf/ansible/playbooks/inventory

```code
[webservers]
tomcat ansible_user=caltech ansible_ssh_pass=caltech


[webservers:vars]
project=project01
url=https://github.com/bbrown-caltech/deployment-using-ansible-cm-tool/raw/project01-maven-web-application/project01/target/project01-1.0-SNAPSHOT.war

```

<br />

#### docker/conf/ansible/playbooks/update-tomcat.yaml

```yaml
---
- name: Update Tomcat Application
  hosts: "{{ target }}"
  user: caltech
  tasks:
    - name: Remove Application Files
      command: sh -c 'sudo rm -rf /usr/share/tomcat/work/Catalina/localhost/{{ project }}'

    - name: Stop Running Application
      command: sh -c 'curl -u admin:admin http://localhost:8080/manager/text/stop?path=/{{ project }}'

    - name: Remove Project Files
      command: sh -c 'sudo rm -rf /usr/share/tomcat/webapps/{{ project }}'

    - name: Download Updated War File
      command: sh -c 'sudo wget -O /usr/share/tomcat/webapps/{{ project }}.war {{ url }}'

    - name: Start Application
      command: sh -c 'curl -u admin:admin http://localhost:8080/manager/text/start?path=/{{ project }}'

```

<br />

### Docker-Compose

This project leverages the multi-node Jenkins instances from last project and includes a Sonatype Nexus repository manager

#### docker/.env

```code
################################################################################################
#       3RD PARTY IMAGES
################################################################################################
NGINX=nginx:latest
NEXUS=sonatype/nexus3:3.33.0

```

<br />

#### docker/docker-compose.yml

```yaml
version: '3.5'
services:

##########################################################################
#  CORE SERVICES
##########################################################################
  nginx:
    container_name: nginx
    image: ${NGINX}
    restart: unless-stopped
    networks:
      - simplilearn
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./conf/:/etc/nginx/
      - ./certs:/etc/nginx/certs

##########################################################################
#  CI/CD Application(s) and Service(s)
##########################################################################

  # Jenkins Nodes
  jenkins-master:
    container_name: jenkins-master
    build:
      context: .
      dockerfile: ./docker-files/Jenkins.Dockerfile
    user: root
    restart: unless-stopped
    networks:
      - simplilearn
    environment:
      SNAPSHOT_URL: "http://nexus:8081/repository/maven-snapshots/"
      RELEASE_URL: "http://nexus:8081/repository/maven-releases/"
      GROUP_URL: "http://nexus:8081/repository/maven-group/"
    volumes:
      - jenkins_master_data:/var/jenkins_home:z
      - /etc/docker:/etc/docker
      - "/root/.docker:$HOME/.docker"
      - /usr/bin/docker:/usr/bin/docker
      - /var/run/docker.sock:/var/run/docker.sock
      - ./conf/.ssh:/var/jenkins_home/.ssh
      - ./conf/.m2:/var/jenkins_home/.m2

  jenkins-node01:
    container_name: jenkins-node01
    build:
      context: .
      dockerfile: ./docker-files/Jenkins.Dockerfile
    user: root
    restart: unless-stopped
    networks:
      - simplilearn
    environment:
      SNAPSHOT_URL: "http://nexus:8081/repository/maven-snapshots/"
      RELEASE_URL: "http://nexus:8081/repository/maven-releases/"
      GROUP_URL: "http://nexus:8081/repository/maven-group/"
    volumes:
      - jenkins_node01_data:/var/jenkins_home:z
      - /etc/docker:/etc/docker
      - "/root/.docker:$HOME/.docker"
      - /usr/bin/docker:/usr/bin/docker
      - /var/run/docker.sock:/var/run/docker.sock
      - ./conf/.ssh:/var/jenkins_home/.ssh
      - ./conf/.m2:/var/jenkins_home/.m2

  jenkins-node02:
    container_name: jenkins-node02
    build:
      context: .
      dockerfile: ./docker-files/Jenkins.Dockerfile
    user: root
    restart: unless-stopped
    networks:
      - simplilearn
    environment:
      SNAPSHOT_URL: "http://nexus:8081/repository/maven-snapshots/"
      RELEASE_URL: "http://nexus:8081/repository/maven-releases/"
      GROUP_URL: "http://nexus:8081/repository/maven-group/"
    volumes:
      - jenkins_node02_data:/var/jenkins_home:z
      - /etc/docker:/etc/docker
      - "/root/.docker:$HOME/.docker"
      - /usr/bin/docker:/usr/bin/docker
      - /var/run/docker.sock:/var/run/docker.sock
      - ./conf/.ssh:/var/jenkins_home/.ssh
      - ./conf/.m2:/var/jenkins_home/.m2

  # Repository Manager
  nexus:
    container_name: nexus
    image: ${NEXUS}
    restart: unless-stopped
    networks:
      - simplilearn
    volumes:
      - nexus_data:/nexus-data:z

##########################################################################
#  CM Application(s) and Service(s)
##########################################################################
  ansible:
    container_name: ansible
    build:
      context: .
      dockerfile: ./docker-files/Ansible.Dockerfile
    user: root
    restart: unless-stopped
    networks:
      - simplilearn
    volumes:
      - ./conf/ansible/playbooks:/playbooks

##########################################################################
#  Application - Tomcat Server
##########################################################################
  tomcat:
    container_name: tomcat
    build:
      context: .
      dockerfile: ./docker-files/Tomcat.Dockerfile
    user: root
    restart: unless-stopped
    networks:
      - simplilearn

volumes:
  jenkins_master_data:
  jenkins_node01_data:
  jenkins_node02_data:
  nexus_data:

networks:
  simplilearn:
    driver: bridge

```

<br />

#### docker/conf/nginx.conf

```code

events {}

http {
   
    upstream jenkins-master {
        server jenkins-master:8080;
    }

    upstream jenkins-node01 {
        server jenkins-node01:8080;
    }

    upstream jenkins-node02 {
        server jenkins-node02:8080;
    }

    upstream nexus {
        server nexus:8081;
    }

    upstream tomcat {
        server tomcat:8080;
    }

    # Support hhttp2/ websocket handshakes
    map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
    }
    
    
    # redirect http to https
    server {
        listen 80 default_server;
        server_name jenkins-master.brianbrown.me;
        return 301 https://$host$request_uri;
    }
    
    
    # Jenkins Master Node
    server {
        
        listen 443  ssl http2;
        listen [::]:443  ssl http2;
        
        server_name jenkins-master.brianbrown.me;
        
        # Support only TLSv1.2
        ssl_protocols TLSv1.2;
        ssl_certificate                        /etc/nginx/certs/jenkins-master.brianbrown.me.pem;
        ssl_certificate_key                    /etc/nginx/certs/jenkins-master.brianbrown.me.key;
        ssl_client_certificate                 /etc/nginx/certs/jenkins-master.brianbrown.me.crt;
        ssl_verify_client optional_no_ca;
        ssl_verify_depth 3;
        recursive_error_pages on;

        location / {
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
            
            proxy_pass http://jenkins-master;
            proxy_read_timeout  90;
            
            # Fix the “It appears that your reverse proxy set up is broken" error.
            proxy_redirect http://jenkins-master https://jenkins-master.brianbrown.me;

            # Required for new HTTP-based CLI
            proxy_http_version 1.1;
            proxy_request_buffering off;
            # workaround for https://issues.jenkins-ci.org/browse/JENKINS-45651
            # add_header 'X-SSH-Endpoint' 'jenkins-master.brianbrown.me:50022' always;
            add_header 'X-SSH-Endpoint' 'jenkins-master.brianbrown.me:50022' always;
        }

    }

    # Jenkins Worker Node 01
    server {
        
        listen 443  ssl http2;
        listen [::]:443  ssl http2;
        
        server_name jenkins-node01.brianbrown.me;
        
        # Support only TLSv1.2
        ssl_protocols TLSv1.2;
        ssl_certificate                        /etc/nginx/certs/jenkins-node01.brianbrown.me.pem;
        ssl_certificate_key                    /etc/nginx/certs/jenkins-node01.brianbrown.me.key;
        ssl_client_certificate                 /etc/nginx/certs/jenkins-node01.brianbrown.me.crt;
        ssl_verify_client optional_no_ca;
        ssl_verify_depth 3;
        recursive_error_pages on;

        location / {
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
            
            proxy_pass http://jenkins-node01;
            proxy_read_timeout  90;
            
            # Fix the “It appears that your reverse proxy set up is broken" error.
            proxy_redirect http://jenkins-node01 https://jenkins-node01.brianbrown.me;

            # Required for new HTTP-based CLI
            proxy_http_version 1.1;
            proxy_request_buffering off;
            # workaround for https://issues.jenkins-ci.org/browse/JENKINS-45651
            add_header 'X-SSH-Endpoint' 'jenkins-node01.brianbrown.me:50022' always;
            # add_header 'X-SSH-Endpoint' 'jenkins-node01.brianbrown.me:50002' always;
        }

    }

    # Jenkins Worker Node 02
    server {
        
        listen 443  ssl http2;
        listen [::]:443  ssl http2;
        
        server_name jenkins-node02.brianbrown.me;
        
        # Support only TLSv1.2
        ssl_protocols TLSv1.2;
        ssl_certificate                        /etc/nginx/certs/jenkins-node02.brianbrown.me.pem;
        ssl_certificate_key                    /etc/nginx/certs/jenkins-node02.brianbrown.me.key;
        ssl_client_certificate                 /etc/nginx/certs/jenkins-node02.brianbrown.me.crt;
        ssl_verify_client optional_no_ca;
        ssl_verify_depth 3;
        recursive_error_pages on;

        location / {
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
            
            proxy_pass http://jenkins-node02;
            proxy_read_timeout  90;
            
            # Fix the “It appears that your reverse proxy set up is broken" error.
            proxy_redirect http://jenkins-node02 https://jenkins-node02.brianbrown.me;

            # Required for new HTTP-based CLI
            proxy_http_version 1.1;
            proxy_request_buffering off;
            # workaround for https://issues.jenkins-ci.org/browse/JENKINS-45651
            add_header 'X-SSH-Endpoint' 'jenkins-node02.brianbrown.me:50022' always;
            # add_header 'X-SSH-Endpoint' 'jenkins-node02.brianbrown.me:50002' always;
        }

    }


    # Nexus Repository Manager
    server {
        
        listen 443  ssl http2;
        listen [::]:443  ssl http2;
        
        server_name nexus.brianbrown.me;
        
        # Support only TLSv1.2
        ssl_protocols TLSv1.2;
        ssl_certificate                        /etc/nginx/certs/nexus.brianbrown.me.pem;
        ssl_certificate_key                    /etc/nginx/certs/nexus.brianbrown.me.key;
        ssl_client_certificate                 /etc/nginx/certs/nexus.brianbrown.me.crt;
        ssl_verify_client optional_no_ca;
        ssl_verify_depth 3;
        recursive_error_pages on;

        location / {
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
            
            proxy_pass http://nexus;
            proxy_read_timeout  90;
            
            # Fix the “It appears that your reverse proxy set up is broken" error.
            proxy_redirect http://nexus https://nexus.brianbrown.me;

            # Required for new HTTP-based CLI
            proxy_http_version 1.1;
            proxy_request_buffering off;
            
        }

    }


    # Tomcat Application Server
    server {
        
        listen 443  ssl http2;
        listen [::]:443  ssl http2;
        
        server_name tomcat.brianbrown.me;
        
        # Support only TLSv1.2
        ssl_protocols TLSv1.2;
        ssl_certificate                        /etc/nginx/certs/tomcat.brianbrown.me.pem;
        ssl_certificate_key                    /etc/nginx/certs/tomcat.brianbrown.me.key;
        ssl_client_certificate                 /etc/nginx/certs/tomcat.brianbrown.me.crt;
        ssl_verify_client optional_no_ca;
        ssl_verify_depth 3;
        recursive_error_pages on;

        location / {
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
            
            proxy_pass http://tomcat;
            proxy_read_timeout  90;
            
            # Fix the “It appears that your reverse proxy set up is broken" error.
            proxy_redirect http://tomcat https://tomcat.brianbrown.me;

            # Required for new HTTP-based CLI
            proxy_http_version 1.1;
            proxy_request_buffering off;
            
        }

    }


}

```
