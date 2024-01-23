source ./modules/utils.sh

delete_network() {
	print_yellow "\nDeleting network..."

	if gcloud compute networks describe $NETWORK_NAME &>/dev/null; then
		gcloud compute networks delete $NETWORK_NAME --quiet || {
			print_red "Error deleting $NETWORK_NAME. Please check for errors."
			exit 1
		}
		print_green "Deleted Network: $NETWORK_NAME"
	else
		print_green "Network $NETWORK_NAME does not exist"
	fi
}
