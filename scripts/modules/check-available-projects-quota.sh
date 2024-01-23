check_available_projects_quota() {

	# get list of projects linked to the billing account
	projects_list=$(gcloud billing projects list --billing-account=$BILLING_ACCOUNT_ID --format="value(PROJECT_ID)")

	# check if current project is in the list of projects linked to the billing account
	case "${projects_list[@]}" in
	*"$PROJECT_ID"*) project_exists=1 ;;
	*) project_exists=0 ;;
	esac

	if [[ $project_exists -eq 1 ]]; then
		return
	fi

	# count number of projects in the billing account
	project_count=$(echo $projects_list | wc -w)

	if [[ $project_count -lt 5 ]]; then
		return
	fi

	print_red "\nYou have exceeded the quota of 5 projects per billing account."
	print_red "Please remove some projects from the billing account and retry."

	exit 1
}
