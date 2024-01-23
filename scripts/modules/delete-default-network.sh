delete_default_network() {
	print_yellow "\nDeleting default network..."

	if ! gcloud compute networks list --format="value(name)"; then
		print_green "No networks exist."
		return
	fi

	networks=$(gcloud compute networks list --format="value(name)")
	if ! echo $networks | grep -E "default"; then
		print_green "No default networks exist."
		return
	fi

	if [[ "$USE_DEFAULTS"=true ]]; then
		response="yes"
	else
		echo -e "\n"
		read -p "Are you sure you want to delete these networks? (yes/no) " response
	fi

	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		for network in $default_networks; do
			gcloud compute networks delete $network --quiet || {
				print_red "Failed to delete network $network. Please check for errors."
			}
		done
		print_green "Default Network deleted."
		return
	fi

	print_red "Aborting deletion."
	exit 1
}
