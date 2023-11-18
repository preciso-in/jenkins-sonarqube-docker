<details>
<summary>Authentication on local workstation to run TF script</summary>

##### Authenticate to GCP for Terraform Access

```
gcloud auth application-default login
```

</details>
 <br>

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
<summary>Housekeeping (Updates, cleanup)</summary>

##### Miscellaneous Housekeeping

> Update gcloud components

```
sudo gcloud components update -y
```

> Gcloud setup
> Reinitialise with a completely new configuration.

```
gcloud init
```

> Terraform destroy

```
terraform destroy -auto-approve
```

</details>
<br>

<details>
<summary>Terraform</summary>

##### Terraform setup

> Setup TF

```
terraform init
terraform fmt
terraform validate
```

> Apply TF configuration

```
terraform apply -auto-approve
```

##### Add Git Hook for checking Story-ID in every commit message

```
$ chmod +x script.sh
$ sh script.sh
```

</details>
<br>

<details>
<summary>Get IP Addresses</summary>

```
JENKINS_IP=$(gcloud compute instances describe $JENKINS_INSTANCE_NAME \
 --format="value(networkInterfaces.accessConfigs[0].natIP)")

SONARQUBE_IP=$(gcloud compute instances describe $SONARQUBE_INSTANCE_NAME \
 --format="value(networkInterfaces.accessConfigs[0].natIP)")

DOCKER_IP=$(gcloud compute instances describe $DOCKER_INSTANCE_NAME \
 --format="value(networkInterfaces.accessConfigs[0].natIP)")
```

</details>
<br>

<details>
<summary>Jenkins Check</summary>

> Loginto Jenkins server and check service status

```
gcloud compute ssh ci-server
systemctl status jenkins
```

> Open Jenkins URL in browser

```
echo $JENKINS_IP:8080
```

</details>
<br>

<details>
<summary>Setup Jenkins Server</summary>

#### Get Jenkins InitialAdminPassword

```
gcloud compute ssh ci-server
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
exit
```

##### Create Jenkins User

> Go to $JENKINS_IP:8080
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

</details>
<br>

<details>
<summary>Github Webhook Setup</summary>

> Copy Jenkins Server URL into Payload URL

```
echo http://$JENKINS_IP:8080/github-webhook/
```

> Select "Pushes" and "Pull Requests" in "Which events would you like to trigger this webhook?" > "Let me select individual events."

</details>
<br>

<details>
<summary>SonarQube setup in Jenkins</summary>

##### Sonarqube setup in Jenkins

> Install plugins

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

</details>
<br>

<details>
<summary>Sonarqube Server setup</summary>

##### Run Sonarqube on Sonarqube Server

```
cd /usr/local/sonarqube-10.2.0.77647/bin/linux-x86-64/
./sonar.sh console
```

##### Open SonarQube Server in Browser

```
echo $SONARQUBE_IP:9000
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
<br>

<details>
<summary>Sonarqube setup continued on Jenkins</summary>

##### Configure System in Jenkins

> Jenkins Dashboard > Manage Jenkins > System > SonarQube Servers > "Add Sonarqube"

```
Name: Sonar-server
Server URL: $ echo http://$SONARQUBE_IP:9000
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
<br>

<details>
<summary>Docker Server Setup</summary>

##### Docker server setup

> Loginto docker server

```
docker compute ssh container-server
```

> Set password for user ubuntu

```
sudo passwd ubuntu
```

</details>
<br>

<details>
<summary>SSH access to Docker server from Jenkins server </summary>

##### Setup access in Jenkins server for Docker

> Add authorised ssh key for ubuntu user on Docker server

```
ssh-keygen

ssh-copy-id ubuntu@$DOCKER_IP
```

</details>
<br>

<details>
<summary>Jenkins build stage for Docker</summary>

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
<br>

<details>
<summary>Check Deployed website</summary>

> Open following link in browser

```
echo $DOCKER_IP:8085
```

</details>
<br>

<details>
<summary>Clean up</summary>

##### Destroy Project

```
terraform destroy -auto-approve
```

</details>
<br>
