#! /bin/bash

gcloud compute ssh $SONARQUBE_INSTANCE_NAME
sudo apt update -y
sudo apt install openjdk-17-jre unzip -y

cd /usr/local
echo "Installing sonarqube"
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.2.0.77647.zip
echo "Unzipping sonarqube"
unzip sonarqube-10.2.0.77647.zip
echo "Changing ownership"
ls
chown nileshparkhe -R sonarqube-10.2.0.77647/
