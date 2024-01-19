update_gcloud_config() {
	print_yellow "\nUpdating gcloud config"
	gcloud config set compute/region $REGION --quiet &>/dev/null
	gcloud config set project $PROJECT_ID --quiet &>/dev/null
	gcloud config set compute/zone $REGION-a --quiet &>/dev/null

	print_green "Gcloud Config is set to:"

	gcloud config list
	print_green ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
}
