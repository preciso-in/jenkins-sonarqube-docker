source ./modules/utils.sh

delete_subnets() {
	print_yellow "\nDeleting sub-networks..."

	if gcloud compute networks subnets describe $SUBNET_NAME &>/dev/null; then
		gcloud compute networks subnets delete $SUBNET_NAME --region=$REGION --quiet &>/dev/null || {
			print_red "Error deleting $SUBNET_NAME. Please check for errors."
			exit 1
		}
		print_green "Deleted Sub-network: $SUBNET_NAME"
	else
		print_green "Sub-network $SUBNET_NAME does not exist"
	fi
}
