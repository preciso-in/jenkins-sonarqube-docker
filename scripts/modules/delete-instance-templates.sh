source ./modules/utils.sh

delete_instance_templates() {
	print_yellow "\nDeleting instance templates..."

	if gcloud compute instance-templates describe $INSTANCE_TEMPLATE_NAME &>/dev/null; then
		gcloud compute instance-templates delete $INSTANCE_TEMPLATE_NAME --quiet &>/dev/null || {
			print_red "Error deleting $INSTANCE_TEMPLATE_NAME. Please check for errors."
			exit 1
		}
		print_green "Deleted Instance Template: $INSTANCE_TEMPLATE_NAME"
	else
		print_green "Instance Template $INSTANCE_TEMPLATE_NAME does not exist"
	fi
}
