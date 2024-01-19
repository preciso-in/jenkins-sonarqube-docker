# Instructions to setup GCP deployment that uses a VM to serve website

Switch to ./scripts folder on your terminal and follow instructions below.
You can update default values by changing default values listed in default-env.sh

```
cd scripts
chmod +x gcloud-cli.sh
export PATH=$PATH:${pwd}
gcloud-cli.sh
source default-env.sh
```

<details>
<summary>Open Jenkins Server</summary>

##### Check if Jenkins is running

> Loginto Jenkins server and check service status

```
gcloud compute ssh $JENKINS_INSTANCE_NAME
systemctl status jenkins
```

##### Exit from SSH

```
exit
```

##### Get IP address of Jenkins Server

```
JENKINS_SERVER_IP=$(gcloud compute instances describe $JENKINS_INSTANCE_NAME \
 --format="value(networkInterfaces.accessConfigs[0].natIP)")
echo $JENKINS_SERVER_IP

```

##### Open Jenkins URL in browser

```
echo $JENKINS_SERVER_IP:8080
```

</details>
<br/>

<details>
<summary>Jenkins Server Setup</summary>

##### Get Jenkins InitialAdminPassword

```
gcloud compute ssh $JENKINS_INSTANCE_NAME
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
exit
```

##### Create Jenkins User

> Go to $JENKINS_SERVER_IP:8080
> Input Jenkins InitialAdminPassword

```
user: Nilesh
pwd: 12345
```

##### Create Freestyle Project "Automated-Pipeline"

> Add Github details of git repo

```
https://github.com/nparkhe83/jenkins-sonarqube-docker.git
```

> Add branch specifier as "\*/main"
> Check "GitHub hook trigger for GITScm polling" in Build Trigger

##### Create Webhooks in Github

> Copy Jenkins Server URL into Payload URL

```
echo http://$JENKINS_SERVER_IP:8080/github-webhook/
```

> Select "Pushes" and "Pull Requests" in "Which events would you like to trigger this webhook?" > "Let me select individual events."

</details>
<br/>

<details>
<summary>Start SonarQube server</summary>

##### Run Sonarqube on Sonarqube Server

```
gcloud compute ssh $SONARQUBE_INSTANCE_NAME

cd /usr/local/sonarqube-10.2.0.77647/bin/linux-x86-64/
./sonar.sh console
```

</details>
<br/>

<details>
<summary>Open SonarQube Server</summary>

##### Get IP address of Sonarqube Server

```
SONARQUBE_SERVER_IP=$(gcloud compute instances describe $SONARQUBE_INSTANCE_NAME \
 --format="value(networkInterfaces.accessConfigs[0].natIP)")
echo $SONARQUBE_SERVER_IP

```

##### Open SonarQube Server in Browser

```
echo $SONARQUBE_SERVER_IP:9000
```

> user: admin
> pwd: admin
> Change password to 12345

##### Configure SonarQube Server

> Select Create Project Manually

```
Project Display Name = Onix-Website-Scan
Project Key = Onix-Website-Scan
Main Branch Name = Main
```

> Choose the baseline for new code for this project

```
Use the global setting.
Previous version
Any code that has changed since the previous version is considered new code.
Recommended for projects following regular versions or releases.
```

> Select CI Method

`Jenkins`

> Select Devops Platform

`Github`

> Analyze your project with Jenkins in Step 4

`Create a JenkinsFile - Choose Other (For JS, TS...)`

##### Create Token in SonarQube

> Go to Admin Profile at top right hand
> A > My Account > Security > Generate Token
> _Copy this token and keep it safe_
> ex. sqp_9d9c1f8c3631edaf75c1726a2bd7367e11547b81

```
Name: Jenkins-token
Type: Project Analysis Token
Project: Onix-Website-Scan
Expires in: 30 days
```

</details>
<br/>

<details>
<summary>SonarQube integration in Jenkins Server</summary>

##### Install Jenkins Plugins

> Install

```
Sonarqube Scanner
SSH2 Easy
```

##### Configure Tools in Jenkins

> Jenkins Dashboard > Manage Jenkins > Tools > SonarQube Scanner Installations > "Add Sonarqube Scanner"

```
Name: SonarScanner
Check "Install Automatically"
```

##### Configure System in Jenkins

> Jenkins Dashboard > Manage Jenkins > System > SonarQube Servers > "Add Sonarqube"

```
Name: Sonar-server
Server URL: $ echo http://$SONARQUBE_SERVER_IP:9000
```

> In same section, add Sonarqube token
> Sonar Authentication Token > "Add" > "Jenkins"

```
Kind: Secret Text
Secret: [SONAR_TOKEN] ex.sqp_9d9c1f8c3631edaf75c1726a2bd7367e11547b81
ID: sonar-token
```

> Then select token in dropdown
> Sonar Authentication Token > "sonar-token" in dropdown

##### Create Buildstep in Pipeline

> Jenkins Dashboard > [JOB_NAME] > Configure > "Add Build Step" > "Execute SonarQube Scanner"

```
Analysis Properties: sonar.projectKey=Onix-Website-Scan
```

##### Run Pipeline

> Dashboard > [JOB_NAME] > "Build Now"

</details>
<br/>

<details>
<summary>Docker Server Startup</summary>

##### Run Docker

> Check if Docker is running

```
sudo docker run hello-world
```

</details>
<br/>

<details>
<summary>Get access to Docker Server from Jenkins Server</summary>

##### Create SSH Access into Docker-Server on Jenkins server.

> Get Docker IP

```
DOCKER_IP=$(gcloud compute instances describe $DOCKER_INSTANCE_NAME \
 --format="value(networkInterfaces.accessConfigs[0].natIP)")
```

> Switch to Jenkins user on jenkins server

```
gcloud compute ssh $JENKINS_INSTANCE_NAME
@jenkins:sudo su jenkins
@jenkins:$ ssh ubuntu@$DOCKER_IP
```

> Add public key of Jenkins in Docker if not already done.

```
@docker:$ sudo su // Switch to root user
@docker:# vim /etc/ssh/sshd_config
```

> Edit sshd_config file

```
Uncomment PubkeyAuthentication yes
PasswordAuthentication yes
```

> Restart sshd service

```
# systemctl restart sshd
```

> Add ubuntu user password in Docker server

```
# passwd ubuntu // ex. 12345
```

> Try SSH again from jenkins server to ssh

```
jenkins@jenkins:$ ssh ubuntu@$DOCKER_IP
// ssh contains IP address encoding. Hence, everytime, the IP address changes, you have to recreate the SSH key and paste it in the Jenkins config.
```

> Create a public and private key in Jenkins server

```
@jenkins:$ ssh-keygen
```

> Add key to jenkins-server (To avoid typing password again)

```
@jenkins:$ ssh-copy-id ubuntu@$DOCKER_IP
```

> Log into the Docker server and create a folder to save nginx site assets

```
@jenkins:$ ssh ubuntu@DOCKER_IP
@docker:$ mkdir website
```

> Grant ubuntu user access to run docker commands

```
@docker:$ sudo usermod -aG docker ubuntu
@docker:$ newgrp docker
@docker:$ docker ps // This should run now.
```

</details>
<br/>

<details>
<summary>Integrate Docker build step in Jenkins</summary>

##### Create Docker build step in Jenkins

> Dashboard > Manage Jenkins > System > Server groups > Server Group List

```
Group Name: Docker-Servers
SSH Port: 22
User Name: ubuntu
Password: 12345 // Password entered when we were in Docker server as root.
```

> Dashboard > Manage Jenkins > System > Server lists

```
Server Group: Docker-Servers
Server Name: Docker-1
Server IP: $DOCKER_IP
```

> Dashboard > [JOB_NAME] > Configure > Build Steps > "Add Build Step" > "Execute Shell"

```
Command: scp -r ./* ubuntu@$DOCKER_IP:~/website/
```

> Dashboard > [JOB_NAME] > Configure > Build Steps > "Add Build Step" > "Remote Shell"

```
Target Server: Docker-Servers~~Docker-1~~$DOCKER_IP //Dropdown
shell:
cd /home/ubuntu/website
docker build -t mywebsite .
docker run -d -p 8085:80 --name=Onix-Website mywebsite
```

</details>
<br/>

<details>
<summary>Check Website
</summary>
##### Go to Docker IP to check website

```
$ echo http://$DOCKER_IP:8085
```

</details>
<br/>

# Miscellaneous commands you may need in addition to script

<details>

<summary>GCP Commands</summary>

##### Log in to GCP

```
gcloud auth login
```

##### Create project in GCP

```
gcloud projects create $PROJECT_ID
gcloud init
```

##### List billing accounts on user

```
gcloud billing accounts list
```

##### Link billing account to project

```
BILLING_ACCT_ID=$(gcloud billing accounts list --format="value(ACCOUNT_ID)")
gcloud billing projects link $PROJECT_ID \
  --billing-account=$BILLING_ACCT_ID
```

##### Instance lifecycle commands

```
$ gcloud compute instances stop my-instance
$ gcloud compute instances start my-instance
$ gcloud compute instances describe INSTANCE_NAME --format="get(status)"
$ gcloud compute instances add-metadata my-instance \
    --metadata serial-port-enable=TRUE
```

</details>

<br>
<details>
<summary>Enable Story-id for every commit </summary>

##### Add Git Hook for checking Story-ID in every commit message

```
$ chmod +x script.sh
$ sh script.sh
```

</details>
