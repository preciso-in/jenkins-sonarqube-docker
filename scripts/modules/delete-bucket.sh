source ./modules/utils.sh

delete_bucket() {
	# Get input if user wants to delete project
	print_yellow "Do you want to delete storage bucket: $BUCKET_ID? (y/n)"
	read answer

	# if [ "$answer" = "${answer#[Yy]}" ]; then
	if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		print_yellow "\nDeleting storage bucket: $BUCKET_ID"

		if gsutil ls -b gs://$BUCKET_ID >/dev/null 2>&1; then
			gsutil rm -r gs://$BUCKET_ID || {
				print_red "Error deleting storage bucket: $BUCKET_ID"
				exit 1 # Terminate the script with an error
			}
			print_green "Storage bucket $BUCKET_ID deleted."
		else
			print_green "Storage bucket $BUCKET_ID does not exist."
		fi
	else
		print_green "Storage bucket deletion cancelled."
	fi
}
