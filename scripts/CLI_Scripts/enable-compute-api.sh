enable_compute_api() {
	print_yellow "\nEnabling Compute API"

	if gcloud services list --enabled | grep compute >/dev/null 2>&1; then
		print_green "Compute API already enabled"
		return
	fi

	gcloud services enable compute.googleapis.com --quiet --project $PROJECT_ID || {
		print_red "Error enabling Compute API"
		exit 1 # Terminate the script with an error
	}

	print_green "Compute API enabled"
}
