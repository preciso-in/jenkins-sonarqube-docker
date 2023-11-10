#! /bin/bash

gcloud compute ssh $SONARQUBE_INSTANCE_NAME
sudo apt update -y
sudo apt install openjdk-17-jre unzip -y

cd /usr/local
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.2.0.77647.zip
unzip sonarqube-10.2.0.77647.zip

chown nileshparkhe -R sonarqube-10.2.0.77647/
