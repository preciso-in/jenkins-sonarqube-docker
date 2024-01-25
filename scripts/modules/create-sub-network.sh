create_sub_network() {

	print_yellow "\nCreating sub-network..."

	if gcloud compute networks subnets describe $SUBNET_NAME --region=$REGION &>/dev/null; then
		print_green "Sub-network $SUBNET_NAME already exists."
		return
	else
		gcloud compute networks subnets create $SUBNET_NAME \
			--network=$NETWORK_NAME \
			--range=10.0.20.0/24 \
			--region=$REGION &>/dev/null || {
			print_red "Failed to create sub-network. Please check for errors."
			exit 1
		}
	fi

	print_green "Sub-network $SUBNET_NAME created."
}
