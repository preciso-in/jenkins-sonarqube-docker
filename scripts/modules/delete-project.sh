source ./modules/utils.sh

delete_project() {
	# Get input if user wants to delete project
	print_yellow "Do you want to delete project: $PROJECT_ID? (y/n)"
	read answer

	# if [ "$answer" = "${answer#[Yy]}" ]; then
	if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		print_yellow "\nDeleting project: $PROJECT_ID"

		if gcloud projects describe $PROJECT_ID >/dev/null 2>&1; then
			gcloud projects delete $PROJECT_ID --quiet &>/dev/null || {
				print_red "Error deleting project: $PROJECT_ID"
				exit 1 # Terminate the script with an error
			}
			print_green "Project $PROJECT_ID deleted."
		else
			print_green "Project $PROJECT_ID does not exist."
		fi
	else
		print_green "Project deletion cancelled."
	fi
}
