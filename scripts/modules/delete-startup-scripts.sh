source ./modules/utils.sh

delete_startup_scripts() {
	print_yellow "\nDeleting startup scripts..."

	gsutil rm gs://$BUCKET_ID/jenkins-startup-script.sh &>/dev/null ||{
		print_green "Jenkins startup script does not exist"
	}
	gsutil rm gs://$BUCKET_ID/sonarqube-startup-script.sh &>/dev/null ||{
		print_green "Sonarqube startup script does not exist"
	}
	gsutil rm gs://$BUCKET_ID/docker-startup-script.sh &>/dev/null ||{
		print_green "Docker startup script does not exist"
	}
	print_green "Deleted startup scripts"
}
