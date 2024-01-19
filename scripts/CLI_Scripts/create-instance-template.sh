create_instance_template() {

	print_yellow "\nCreating instance template $INSTANCE_TEMPLATE_NAME"
	if gcloud compute instance-templates describe $INSTANCE_TEMPLATE_NAME &>/dev/null; then
		print_green "Instance template $INSTANCE_TEMPLATE_NAME Already exists"
	else
		gcloud beta compute instance-templates create $INSTANCE_TEMPLATE_NAME \
			--project=$PROJECT_ID \
			--machine-type=n1-standard-1 \
			--network-interface=network-tier=PREMIUM,subnet=$SUBNET_NAME \
			--no-restart-on-failure \
			--maintenance-policy=TERMINATE \
			--provisioning-model=SPOT \
			--instance-termination-action=DELETE \
			--max-run-duration=3600s \
			--service-account=$SVC_ACCOUNT \
			--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
			--region=us-central1 \
			--create-disk=auto-delete=yes,boot=yes,device-name=jenkins-sonarqube-docker-ubuntu,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20231213,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot \
			--shielded-vtpm \
			--shielded-integrity-monitoring \
			--reservation-affinity=any &>/dev/null

		print_green "Instance template $INSTANCE_TEMPLATE_NAME created"
	fi
}
