#!/bin/bash

/bin/su - tomcat -c /usr/share/tomcat/bin/startup.sh

rm -rf /run/sshd
mkdir -p /run/sshd

/usr/sbin/sshd -D
