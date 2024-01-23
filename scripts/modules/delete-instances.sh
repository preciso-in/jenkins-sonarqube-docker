delete_instances() {
	print_yellow "\nDeleting Jenkins instance"
	if gcloud compute instances describe ${JENKINS_INSTANCE_NAME} &>/dev/null; then
		gcloud compute instances delete $JENKINS_INSTANCE_NAME --quiet &>/dev/null || {
			print_red "Error deleting $JENKINS_INSTANCE_NAME. Please check for errors."
			exit 1
		}
		print_green "Deleted Jenkins Instance: $JENKINS_INSTANCE_NAME"
	else
		print_green "Instance ${JENKINS_INSTANCE_NAME} does not exist"
	fi

	print_yellow "\nDeleting Sonarqube instance"
	if gcloud compute instances describe ${SONARQUBE_INSTANCE_NAME} &>/dev/null; then
		gcloud compute instances delete $SONARQUBE_INSTANCE_NAME --quiet &>/dev/null || {
			print_red "Error deleting $SONARQUBE_INSTANCE_NAME. Please check for errors."
			exit 1
		}
		print_green "Deleted Sonarqube Instance: $SONARQUBE_INSTANCE_NAME"
	else
		print_green "Instance ${SONARQUBE_INSTANCE_NAME} does not exist"
	fi

	print_yellow "\nDeleting Docker instance"
	if gcloud compute instances describe ${DOCKER_INSTANCE_NAME} &>/dev/null; then
		gcloud compute instances delete $DOCKER_INSTANCE_NAME --quiet &>/dev/null || {
			print_red "Error deleting $DOCKER_INSTANCE_NAME. Please check for errors."
			exit 1
		}
		print_green "Deleted Docker Instance: $DOCKER_INSTANCE_NAME"
	else
		print_green "Instance ${DOCKER_INSTANCE_NAME} does not exist"
	fi
}
