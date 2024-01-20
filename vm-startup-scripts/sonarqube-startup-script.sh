#! /bin/bash

gcloud compute ssh $SONARQUBE_INSTANCE_NAME
sudo apt update -y
sudo apt install openjdk-17-jre unzip -y

cd /usr/local
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.2.0.77647.zip
unzip sonarqube-10.2.0.77647.zip

rm -f sonarqube-10.2.0.77647.zip

chown nileshparkhe -R sonarqube-10.2.0.77647/

# Following commands will not work because of restrictions on root user.
# Cannot run following commands as root user.
# No solution found to run the following commands from the startup script.
# cd /usr/local/sonarqube-10.2.0.77647/bin/linux-x86-64/

# ./sonar.sh console
