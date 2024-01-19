create_sub_network() {

	print_yellow "\nCreating sub-network..."

	subnets=$(gcloud compute networks subnets list --format="value(name)")

	if [[ ! -n "$subnets" ]]; then
		print_green "No Sub-networks exists."
	else
		jsdSubnet=$(echo $subnets | grep -E "jsd-subnet")

		if [[ -n "$jsdSubnet" ]]; then
			print_green "Sub-network already exists."
			return
		fi
	fi

	gcloud compute networks subnets create $SUBNET_NAME \
		--network=$NETWORK_NAME \
		--range=10.0.20.0/24 \
		--region=$REGION || {
		print_red "Failed to create sub-network. Please check for errors."
		exit 1
	}
	print_green "Sub-network $SUBNET_NAME created."
}
