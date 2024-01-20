# Site Deployment on GCP using Jenkins CI/CD

This project demonstrates use of Jenkins to deploy docker container of a Simple Website to Google Cloud Platform after scanning with Sonarqube.

### Using Gcloud CLI to deploy GCP resources

<details>
<summary>
What: Using GCloud CLI, the script achieves the following objectives:</summary>

- Creates Spot VMs that expire in 4 Hours using an instance template
- Created VMs run Jenkins, Sonarqube & Docker Container for Nginx
- Clears default VPC, subnet and creates custom VPC & subnet
- Creates firewall rules required for VMs to communicate with each other.
- VMs are fully configured with Jenkins, Sonarqube & Docker. To achieve this, metadata startup scripts are uploaded in Storage bucket to be used when VMs are created

</details>
<br>

How to run: Run ./scripts/gcloud-cli.sh to create GCP resources required to deploy this app.

Then follow the instructions provided in ./Instructions/CLI-Instructions.md to complete setup of Jenkins, Sonarqube & Docker servers.

### Miscellaneous

##### Provide Defaults in ./default-values.txt if you do not want to provide input flags.

```
Inputs requested are
 - Project ID (Unique)
 - Bucket ID (Unique)
 - Region.

Order of precedence:
	1. Flags provided to CLI
	2. Defaults

```

##### Force Git commit messages to include Story ID using githooks

```
$ chmod +x enforce-story-id.sh
$ sh enforce-story-id.sh
```
