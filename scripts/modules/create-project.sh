source ./modules/utils.sh

create_project() {

	print_yellow "\nCreating project: $PROJECT_ID"

	if gcloud projects describe $PROJECT_ID >/dev/null 2>&1; then
		print_green "Project $PROJECT_ID already exists."

		link_billing_account
		return
	fi

	gcloud projects create $PROJECT_ID || {
		print_red "Error creating project: $PROJECT_ID"
		exit 1 # Terminate the script with an error
	}
	print_green "Project $PROJECT_ID created."

	link_billing_account
}

link_billing_account() {
	billing_info=$(gcloud beta billing projects describe $PROJECT_ID --format="json")
	billing_acct=$(jq -r ".billingAccountName" <<<$billing_info)

	if [[ $billing_acct =~ "billingAccounts" ]]; then
		print_green "\nProject $PROJECT_ID is linked to billing account: $billing_acct"
	else
		BILLING_ACCT_ID=$(gcloud billing accounts list --format="value(ACCOUNT_ID)")
		gcloud billing projects link $PROJECT_ID \
			--billing-account=$BILLING_ACCT_ID
		print_green "\nProject $PROJECT_ID linked to billing account $BILLING_ACCT_ID"
	fi
}
