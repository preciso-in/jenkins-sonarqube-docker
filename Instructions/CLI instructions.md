https://youtu.be/361bfIvXMBI

<details>
<summary>Environment Variables</summary>

##### Set Environment Variables

```
REGION=us-central1
PROJECT_ID=jenkins-sonarqube-docker-2509
NETWORK_NAME=jsd-nw
SUBNET_NAME=jsd-subnet
STORAGE_BUCKET_NAME=startup-script-bucket-1e
INSTANCE_TEMPLATE_NAME=jsd-instance-template
JENKINS_INSTANCE_NAME=ci-server
DOCKER_INSTANCE_NAME=container-server
SONARQUBE_INSTANCE_NAME=code-scanner-server
JENKINS_NETWORK_TAG=ci-server
SONARQUBE_NETWORK_TAG=scanner-server
DOCKER_NETWORK_TAG=container-server
```

</details>
<br/>

<details>

<summary>Housekeeping commands</summary>

##### Instance lifecycle commands

```
$ gcloud compute instances stop my-instance
$ gcloud compute instances start my-instance
$ gcloud compute instances describe INSTANCE_NAME --format="get(status)"
$ gcloud compute instances add-metadata my-instance \
    --metadata serial-port-enable=TRUE
```

##### Add Git Hook for checking Story-ID in every commit message

```
$ chmod +x script.sh
$ sh script.sh
```

</details>
<br/>

<details>

<summary>Set up Project & GCloud CLI</summary>

##### Create project

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

##### Enable compute engine api

```
gcloud services enable compute.googleapis.com --quiet
```

##### Get service account email id created with project

```
SVC_ACCOUNT=$(gcloud iam service-accounts list --format="value(email)")
echo $SVC_ACCOUNT
```

##### Set Default Region and Zone on gcloud

```
gcloud config set compute/region $REGION
gcloud config set compute/zone $REGION-a
```

</details>
<br/>

<details>
<summary>Reset default project settings</summary>

##### Delete VPC firewall rules

```
gcloud compute firewall-rules list
gcloud compute firewall-rules delete default-allow-icmp --quiet
gcloud compute firewall-rules delete default-allow-internal --quiet
gcloud compute firewall-rules delete default-allow-rdp --quiet
gcloud compute firewall-rules delete default-allow-ssh --quiet
```

##### Delete default VPC

```
gcloud compute networks list
gcloud compute networks delete default --quiet
```

##### Create new VPC

```
gcloud compute networks create $NETWORK_NAME \
  --subnet-mode=custom
```

##### Create new subnet in above VPC

```
gcloud compute networks subnets create $SUBNET_NAME \
  --network=$NETWORK_NAME \
  --range=10.0.20.0/24 \
  --region=$REGION
```

##### Create VPC firewall rules to allow debugging and internal communication

```
gcloud compute firewall-rules create allow-icmp \
  --direction=INGRESS \
  --priority=65534 \
  --network=$NETWORK_NAME \
  --source-ranges=0.0.0.0/0 \
  --action=ALLOW \
  --rules=ICMP
gcloud compute firewall-rules create allow-internal \
  --action=ALLOW \
  --direction=INGRESS \
  --priority=65534 \
  --network=$NETWORK_NAME \
  --source-ranges=10.128.0.0/9 \
  --rules=tcp:0-65535,udp:0-65535,icmp
gcloud compute firewall-rules create allow-rdp \
  --direction=INGRESS \
  --priority=65534 \
  --network=$NETWORK_NAME \
  --source-ranges=0.0.0.0/0 \
  --action=ALLOW \
  --rules=tcp:3389
gcloud compute firewall-rules create allow-ssh \
  --direction=INGRESS \
  --priority=65534 \
  --network=$NETWORK_NAME \
  --source-ranges=0.0.0.0/0 \
  --action=ALLOW \
  --rules=tcp:22
gcloud compute firewall-rules list
```

</details>
<br/>

<details>
<summary>Instance Creation</summary>

##### Upload startup script files to Cloud Storage

> Create Storage Bucket to store startup scripts

```
gsutil mb -l $REGION gs://$STORAGE_BUCKET_NAME
```

> Upload startup scripts

```
gsutil cp jenkins-startup-script.sh gs://$STORAGE_BUCKET_NAME
gsutil cp sonarqube-startup-script.sh gs://$STORAGE_BUCKET_NAME
gsutil cp docker-startup-script.sh gs://$STORAGE_BUCKET_NAME
```

##### Create instance template.

// Do NOT select REGIONAL INSTANCE TEMPLATE. It does not work.

```
gcloud beta compute instance-templates create $INSTANCE_TEMPLATE_NAME \
  --project=$PROJECT_ID \
  --machine-type=n1-standard-1 \
  --network-interface=network-tier=PREMIUM,subnet=$SUBNET_NAME \
  --no-restart-on-failure \
  --maintenance-policy=TERMINATE \
  --provisioning-model=SPOT \
  --instance-termination-action=DELETE \
  --max-run-duration=3600s  \
  --service-account=$SVC_ACCOUNT \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
  --region=us-central1 \
	--create-disk=auto-delete=yes,boot=yes,device-name=jenkins-sonarqube-docker-ubuntu,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230907,mode=rw,size=10,type=pd-balanced\
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --reservation-affinity=any
gcloud beta compute instance-templates list
```

##### Create Instances

> Create Jenkins Instance

```
gcloud compute instances create $JENKINS_INSTANCE_NAME \
 --source-instance-template=$INSTANCE_TEMPLATE_NAME \
 --zone=$REGION-a \
 --tags=$JENKINS_NETWORK_TAG \
 --metadata=startup-script-url=gs://$STORAGE_BUCKET_NAME/jenkins-startup-script.sh
```

> Create Sonarqube Instance

```
gcloud compute instances create $SONARQUBE_INSTANCE_NAME \
  --source-instance-template=$INSTANCE_TEMPLATE_NAME \
  --zone=$REGION-a \
  --tags=$SONARQUBE_NETWORK_TAG \
  --metadata=startup-script-url=gs://$STORAGE_BUCKET_NAME/sonarqube-startup-script.sh
```

> Create Docker Instance

```
gcloud compute instances create $DOCKER_INSTANCE_NAME \
  --source-instance-template=$INSTANCE_TEMPLATE_NAME \
  --tags=$DOCKER_NETWORK_TAG \
  --zone=$REGION-a \
  --metadata=startup-script-url=gs://$STORAGE_BUCKET_NAME/docker-startup-script.sh
```

> List created instances

```
gcloud compute instances list
```

> You can check output of metadata scripts in the VM instance details page and then opening the Logs > "Serial port 1 (console)"

</details>
<br/>

<details>
<summary>Jenkins Server Startup</summary>

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

</details>
<br/>

<details>
<summary>GCP Network configuration for Jenkins Server</summary>

##### Get IP address of Jenkins Server

```
JENKINS_SERVER_IP=$(gcloud compute instances describe $JENKINS_INSTANCE_NAME \
 --format="value(networkInterfaces.accessConfigs[0].natIP)")
echo $JENKINS_SERVER_IP

```

##### Create firewall-rule to allow access to Jenkins Server

> Add network tag for firewall-rule to apply to Jenkins Server

```
gcloud compute instances add-tags $JENKINS_INSTANCE_NAME \
  --tags=$JENKINS_NETWORK_TAG
```

> Add Firewall rule

```
gcloud compute firewall-rules create access-jenkins \
 --direction=INGRESS \
 --priority=1000 \
 --network=$NETWORK_NAME \
  --action=ALLOW \
  --rules=tcp:8080 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$JENKINS_NETWORK_TAG
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
cd /usr/local/sonarqube-10.2.0.77647/bin/linux-x86-64/
./sonar.sh console
```

</details>
<br/>

<details>
<summary>GCP Network configuration for SonarQube Server</summary>

##### Create firewall-rule to allow access to Sonarqube Server

> Add network tag for firewall-rule to apply to Jenkins Server

```
gcloud compute instances add-tags $SONARQUBE_INSTANCE_NAME \
  --tags=$SONARQUBE_NETWORK_TAG
```

> Add Firewall rule

```
gcloud compute firewall-rules create access-sonarqube \
 --direction=INGRESS \
 --priority=1000 \
 --network=$NETWORK_NAME \
  --action=ALLOW \
  --rules=tcp:9000 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$SONARQUBE_NETWORK_TAG
```

##### Get IP address of Sonarqube Server

```
SONARQUBE_SERVER_IP=$(gcloud compute instances describe $SONARQUBE_INSTANCE_NAME \
 --format="value(networkInterfaces.accessConfigs[0].natIP)")
echo $SONARQUBE_SERVER_IP

```

</details>
<br/>

<details>
<summary>SonarQube Server Setup</summary>

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
<summary>GCP Network Config for Docker Server</summary>

##### Run Jenkins Pipeline to start docker nginx server

##### Allow Docker port access to internet

> Add network tag for firewall-rule to apply to Jenkins Server

```
gcloud compute instances add-tags $DOCKER_INSTANCE_NAME \
  --tags=$DOCKER_NETWORK_TAG
```

> Add Firewall rule

```
gcloud compute firewall-rules create access-docker \
 --direction=INGRESS \
 --priority=1000 \
 --network=$NETWORK_NAME \
  --action=ALLOW \
  --rules=tcp:8085 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=$DOCKER_NETWORK_TAG
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
