delete_firewall_rules() {
	print_yellow "\nDeleting firewall rules..."

	print_yellow "\nDeleting firewall rule allow-icmp"
	if gcloud compute firewall-rules describe allow-icmp &>/dev/null; then
		gcloud compute firewall-rules delete allow-icmp --quiet &>/dev/null || {
			print_red "Error deleting firewall rule allow-icmp. Please check for errors."
			exit 1
		}
		print_green "Deleted firewall rule allow-icmp"
	else
		print_green "Firewall rule allow-icmp does not exist"
	fi

	print_yellow "\nDeleting firewall rule allow-internal"
	if gcloud compute firewall-rules describe allow-internal &>/dev/null; then
		gcloud compute firewall-rules delete allow-internal --quiet &>/dev/null || {
			print_red "Error deleting firewall rule allow-internal. Please check for errors."
			exit 1
		}
		print_green "Deleted firewall rule allow-internal"
	else
		print_green "Firewall rule allow-internal does not exist"
	fi

	print_yellow "\nDeleting firewall rule allow-rdp"
	if gcloud compute firewall-rules describe allow-rdp &>/dev/null; then
		gcloud compute firewall-rules delete allow-rdp --quiet &>/dev/null || {
			print_red "Error deleting firewall rule allow-rdp. Please check for errors."
			exit 1
		}
		print_green "Deleted firewall rule allow-rdp"
	else
		print_green "Firewall rule allow-rdp does not exist"
	fi

	print_yellow "\nDeleting firewall rule allow-ssh"
	if gcloud compute firewall-rules describe allow-ssh &>/dev/null; then
		gcloud compute firewall-rules delete allow-ssh --quiet &>/dev/null || {
			print_red "Error deleting firewall rule allow-ssh. Please check for errors."
			exit 1
		}
		print_green "Deleted firewall rule allow-ssh"
	else
		print_green "Firewall rule allow-ssh does not exist"
	fi

	print_yellow "\nDeleting firewall rule allow-jenkins"
	if gcloud compute firewall-rules describe allow-jenkins &>/dev/null; then
		gcloud compute firewall-rules delete allow-jenkins --quiet &>/dev/null || {
			print_red "Error deleting firewall rule allow-jenkins. Please check for errors."
			exit 1
		}
		print_green "Deleted firewall rule allow-jenkins"
	else
		print_green "Firewall rule allow-jenkins does not exist"
	fi

	print_yellow "\nDeleting firewall rule allow-sonarqube"
	if gcloud compute firewall-rules describe allow-sonarqube &>/dev/null; then
		gcloud compute firewall-rules delete allow-sonarqube --quiet &>/dev/null || {
			print_red "Error deleting firewall rule allow-sonarqube. Please check for errors."
			exit 1
		}
		print_green "Deleted firewall rule allow-sonarqube"
	else
		print_green "Firewall rule allow-sonarqube does not exist"
	fi

	print_yellow "\nDeleting firewall rule allow-docker"
	if gcloud compute firewall-rules describe allow-docker &>/dev/null; then
		gcloud compute firewall-rules delete allow-docker --quiet &>/dev/null || {
			print_red "Error deleting firewall rule allow-docker. Please check for errors."
			exit 1
		}
		print_green "Deleted firewall rule allow-docker"
	else
		print_green "Firewall rule allow-docker does not exist"
	fi
}
