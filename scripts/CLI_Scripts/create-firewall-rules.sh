create_firewall_rules() {
	print_yellow "\nCreating firewall rules..."

	# Check and create firewall rule allow-icmp
	if gcloud compute firewall-rules describe allow-icmp &>/dev/null; then
		print_green "Firewall rule allow-icmp already exists"
	else
		print_yellow "Creating firewall rule allow-icmp"
		gcloud compute firewall-rules create allow-icmp \
			--direction=INGRESS \
			--priority=65534 \
			--network=$NETWORK_NAME \
			--source-ranges=0.0.0.0/0 \
			--action=ALLOW \
			--rules=ICMP \
			&>/dev/null || {
			print_red "Error creating firewall rule allow-icmp. Please check for errors."
			exit 1
		}
		print_green "Created firewall rule allow-icmp"
	fi

	# Check and create firewall rule allow-internal
	if gcloud compute firewall-rules describe allow-internal &>/dev/null; then
		print_green "Firewall rule allow-internal already exists"
	else
		print_yellow "Creating firewall rule allow-internal"
		gcloud compute firewall-rules create allow-internal \
			--action=ALLOW \
			--direction=INGRESS \
			--priority=65534 \
			--network=$NETWORK_NAME \
			--source-ranges=10.128.0.0/9 \
			--rules=tcp:0-65535,udp:0-65535,icmp \
			&>/dev/null || {
			print_red "Error creating firewall rule allow-internal. Please check for errors."
			exit 1
		}
		print_green "Created firewall rule allow-internal"
	fi

	# Check and create firewall rule allow-rdp
	if gcloud compute firewall-rules describe allow-rdp &>/dev/null; then
		print_green "Firewall rule allow-rdp already exists"
	else
		print_yellow "Creating firewall rule allow-rdp"
		gcloud compute firewall-rules create allow-rdp \
			--action=ALLOW \
			--direction=INGRESS \
			--priority=65534 \
			--network=$NETWORK_NAME \
			--source-ranges=0.0.0.0/0 \
			--rules=tcp:3389 \
			&>/dev/null || {
			print_red "Error creating firewall rule allow-rdp. Please check for errors."
			exit 1
		}
		print_green "Created Firewall rule allow-rdp"
	fi

	# Check and create firewall rule allow-rdp
	if gcloud compute firewall-rules describe allow-ssh &>/dev/null; then
		print_green "Firewall rule allow-ssh already exists"
	else
		print_yellow "Creating firewall rule allow-ssh"
		gcloud compute firewall-rules create allow-ssh \
			--action=ALLOW \
			--direction=INGRESS \
			--priority=65534 \
			--network=$NETWORK_NAME \
			--source-ranges=0.0.0.0/0 \
			--rules=tcp:22 \
			&>/dev/null || {
			print_red "Error creating firewall rule allow-ssh. Please check for errors."
			exit 1
		}
		print_green "Created Firewall rule allow-ssh"
	fi

	# Check and create firewall rule allow-jenkins
	if gcloud compute firewall-rules describe allow-jenkins &>/dev/null; then
		print_green "Firewall rule allow-jenkins already exists"
	else
		print_yellow "Creating firewall rule allow-jenkins"
		gcloud compute firewall-rules create allow-jenkins \
			--action=ALLOW \
			--direction=INGRESS \
			--priority=1000 \
			--network=$NETWORK_NAME \
			--source-ranges=0.0.0.0/0 \
			--rules=tcp:8080 \
			--target-tags=$JENKINS_NETWORK_TAG \
			&>/dev/null || {
			print_red "Error creating firewall rule allow-jenkins. Please check for errors."
			exit 1
		}
		print_green "Created firewal rule allow-jenkins"
	fi

	# Check and create firewall rule allow-sonarqube
	if gcloud compute firewall-rules describe allow-sonarqube &>/dev/null; then
		print_green "Firewall rule allow-sonarqube already exists"
	else
		print_yellow "Creating firewall rule allow-sonarqube"
		gcloud compute firewall-rules create allow-sonarqube \
			--action=ALLOW \
			--direction=INGRESS \
			--priority=1000 \
			--network=$NETWORK_NAME \
			--source-ranges=0.0.0.0/0 \
			--rules=tcp:9000 \
			--target-tags=$SONARQUBE_NETWORK_TAG \
			&>/dev/null || {
			print_red "Error creating firewall rule allow-sonarqube. Please check for errors."
			exit 1
		}
		print_green "Created firewal rule allow-sonarqube"
	fi

	if gcloud compute firewall-rules describe allow-docker &>/dev/null; then
		print_green "Firewall rule allow-docker already exists"
	else
		print_yellow "Creating firewall rule allow-docker"
		gcloud compute firewall-rules create allow-docker \
			--action=ALLOW \
			--direction=INGRESS \
			--priority=1000 \
			--network=$NETWORK_NAME \
			--source-ranges=0.0.0.0/0 \
			--rules=tcp:8085 \
			--target-tags=$DOCKER_NETWORK_TAG \
			&>/dev/null || {
			print_red "Error creating firewall rule allow-docker. Please check for errors."
			exit 1
		}
		print_green "Created firewal rule allow-docker"
	fi

	print_green "Firewall rules created."
}
