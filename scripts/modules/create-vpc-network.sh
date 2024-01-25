create_vpc_network() {
	print_yellow "\nCreating VPC network..."

	if gcloud compute networks describe $NETWORK_NAME &>/dev/null; then
		print_green "VPC network $NETWORK_NAME already exists."
		return
	else
		gcloud compute networks create $NETWORK_NAME --subnet-mode=custom &>/dev/null || {
			print_red "Failed to create VPC network. Please check for errors."
			exit 1
		}

		print_green "VPC network created."
	fi
}
