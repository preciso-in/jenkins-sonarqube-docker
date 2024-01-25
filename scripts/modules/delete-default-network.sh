delete_default_network() {
	print_yellow "\nDeleting default network..."

	if ! gcloud compute networks list --format="value(name)" &>/dev/null; then
		print_green "No networks exist."
		return
	fi

	networks=$(gcloud compute networks list --format="value(name)") &>/dev/null
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
		gcloud compute networks delete default --quiet &>/dev/null || {
			}
		done
		print_green "Default Network deleted."
		return
	fi

	print_red "Aborting deletion."
	exit 1
}
