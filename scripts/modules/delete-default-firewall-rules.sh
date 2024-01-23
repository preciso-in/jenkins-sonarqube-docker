#! /bin/bash

delete_default_firewall_rules() {
	print_yellow "\nDeleting default firewall rules..."

	firewall_rules=$(gcloud compute firewall-rules list --format="value(name)")

	if [[ ! -n "$firewall_rules" ]]; then
		print_green "No firewall rules found for deletion."
		return
	fi

	default_rules=$(echo $firewall_rules | egrep "default-allow-.*|default-deny-.*") || {
		print_green "No default firewall rules found"
		return
	}

	print_red "default_rules to be deleted: \n$default_rules"

	if [[ "$USE_DEFAULTS"=true ]]; then
		response="yes"
	else
		read -p "Are you sure you want to delete these default firewall rules? (yes/no) " response
	fi

	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		for rule in $default_rules; do
			gcloud compute firewall-rules delete $rule --quiet &>/dev/null || {
				print_red "Failed to delete firewall rule $rule. Please check for errors."
			}
		done

		print_green "Default firewall rules deleted."
	fi
}
