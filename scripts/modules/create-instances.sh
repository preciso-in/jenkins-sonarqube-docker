create_instances() {

	# Create storage bucket to store startup scripts
	# Check if storage bucket exists
	print_yellow "\nCreating Storage bucket to store instance start up scripts"
	if gcloud storage buckets describe gs://${BUCKET_ID} &>/dev/null; then
		print_green "Storage bucket $BUCKET_ID already exists."
	else
		gsutil mb -l ${REGION} gs://${BUCKET_ID} || {
			print_red "Error creating storage bucket. Please check for errors."
			exit 1
		}
		print_green "Created storage bucket: $BUCKET_ID"
	fi

	gsutil cp ../vm-startup-scripts/jenkins-startup-script.sh gs://$BUCKET_ID &>/dev/null
	gsutil cp ../vm-startup-scripts/sonarqube-startup-script.sh gs://$BUCKET_ID &>/dev/null
	gsutil cp ../vm-startup-scripts/docker-startup-script.sh gs://$BUCKET_ID &>/dev/null

	source ./modules/create-instance-template.sh
	create_instance_template

	print_yellow "\nCreating Jenkins instance"

	if gcloud compute instances describe ${JENKINS_INSTANCE_NAME} &>/dev/null; then
		print_green "Instance ${JENKINS_INSTANCE_NAME} already exists"
	else
		gcloud compute instances create $JENKINS_INSTANCE_NAME \
			--source-instance-template=$INSTANCE_TEMPLATE_NAME \
			--zone=$REGION-a \
			--tags=$JENKINS_NETWORK_TAG \
			--metadata=startup-script-url=gs://$BUCKET_ID/jenkins-startup-script.sh &>/dev/null || {
			print_red "Error creating $JENKINS_INSTANCE_NAME. Please check for errors."
			exit 1
		}
		print_green "Created Jenkins Instance: $JENKINS_INSTANCE_NAME"
	fi

	print_yellow "\nCreating Sonarqube instance"
	if gcloud compute instances describe ${SONARQUBE_INSTANCE_NAME} &>/dev/null; then
		print_green "Instance ${SONARQUBE_INSTANCE_NAME} already exists"
	else
		gcloud compute instances create $SONARQUBE_INSTANCE_NAME \
			--source-instance-template=$INSTANCE_TEMPLATE_NAME \
			--zone=$REGION-a \
			--tags=$SONARQUBE_NETWORK_TAG \
			--metadata=startup-script-url=gs://$BUCKET_ID/sonarqube-startup-script.sh &>/dev/null || {
			print_red "Error creating $SONARQUBE_INSTANCE_NAME. Please check for errors."
			exit 1
		}
		print_green "Created Sonarqube Instance: $SONARQUBE_INSTANCE_NAME"
	fi

	print_yellow "\nCreating Docker instance"
	if gcloud compute instances describe ${DOCKER_INSTANCE_NAME} &>/dev/null; then
		print_green "${DOCKER_INSTANCE_NAME} already exists"
	else
		gcloud compute instances create $DOCKER_INSTANCE_NAME \
			--source-instance-template=$INSTANCE_TEMPLATE_NAME \
			--zone=$REGION-a \
			--tags=$DOCKER_NETWORK_TAG \
			--metadata=startup-script-url=gs://$BUCKET_ID/docker-startup-script.sh &>/dev/null || {
			print_red "Error creating $DOCKER_INSTANCE_NAME. Please check for errors."
			exit 1
		}
		print_green "Created Docker Instance: $DOCKER_INSTANCE_NAME"
	fi

	print_green "\nYou can check output of metadata scripts in VM instance details page on GCP.
      Open Logs > Serial port 1 (console)"
}
