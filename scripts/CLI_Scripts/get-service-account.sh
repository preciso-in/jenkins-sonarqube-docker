get_service_account() {
	svc_account=$(gcloud iam service-accounts list --format="value(email)")
	export SVC_ACCOUNT=$svc_account
}
