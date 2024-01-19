create_vpc_network() {
	print_yellow "\nCreating VPC network..."

	networks=$(gcloud compute networks list --format="value(name)")
	if [[ ! -n "$networks" ]]; then
		print_green "No networks exist."
	else
		jsdNw=$(echo $networks | grep -E $NETWORK_NAME)
		if [[ -n "$jsdNw" ]]; then
			print_green "VPC network already exists."
			return
		fi
	fi

	gcloud compute networks create $NETWORK_NAME --subnet-mode=custom || {
		print_red "Failed to create VPC network. Please check for errors."
		exit 1
	}

	print_green "VPC network created."
}
