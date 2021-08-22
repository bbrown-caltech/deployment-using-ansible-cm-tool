#!/bin/bash

echo "Project: $1"
echo "URL: $2"

sudo rm -rf /usr/share/tomcat/work/Catalina/localhost/$1
curl -u admin:admin http://localhost:8080/manager/text/stop?path=/$1
sudo rm -rf /usr/share/tomcat/webapps/$1*
sudo wget -O /usr/share/tomcat/webapps/$1.war $2
curl -u admin:admin http://localhost:8080/manager/text/start?path=/$1

