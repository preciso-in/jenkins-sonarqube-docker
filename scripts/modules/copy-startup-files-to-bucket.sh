copy_startup_files_to_bucket() {
	gsutil cp ../vm-startup-scripts/jenkins-startup-script.sh gs://$BUCKET_ID &>/dev/null
	gsutil cp ../vm-startup-scripts/sonarqube-startup-script.sh gs://$BUCKET_ID &>/dev/null
	gsutil cp ../vm-startup-scripts/docker-startup-script.sh gs://$BUCKET_ID &>/dev/null
}
