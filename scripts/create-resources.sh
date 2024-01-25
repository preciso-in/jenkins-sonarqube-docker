#!/bin/bash
trap 'echo "${BASH_SOURCE[0]}: line ${LINENO}: status ${?}: user ${USER}: func ${FUNCNAME[0]}"' ERR

################################################################################
#               Create App Resources on GCP with GCloud CLI                    #
#                                                                              #
# This script creates Google Cloud resources for deployment of an HTML Site    #
#                                                                              #
# Requirements:                                                                #
# - node                                                                       #
# - gcloud                                                                     #
#                                                                              #
# Usage: 																																		   #
# ./scripts/create-resources.sh \ 																									 #
#   --use-defaults \ 																												   #
#   --project-id <project-id> \  																							 #
#   --region <region> \ 																											 #
#   --bucket-id <storage-bucket-id> \ 														 #
#                                                                              #
# Change History                                                               #
# 11/01/2024  Nilesh Parkhe   Working script that creates Networks,            #
#                             Firewall rules and VM Servers to deploy a        #
#                             Website to the internet.                         #
#                                                                              #
#                                                                              #
################################################################################
################################################################################
################################################################################
#                                                                              #
#  Copyright (C) 2023, 2024 Nilesh Parkhe                                      #
#                                                                              #
#  This program is free software; you can redistribute it and/or modify        #
#  it under the terms of the GNU General Public License as published by        #
#  the Free Software Foundation; either version 2 of the License, or           #
#  (at your option) any later version.                                         #
#                                                                              #
#  This program is distributed in the hope that it will be useful,             #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of              #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
#  GNU General Public License for more details.                                #
#                                                                              #
#  You should have received a copy of the GNU General Public License           #
#  along with this program; if not, write to the Free Software                 #
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   #
#                                                                              #
################################################################################

# Exit on error
set -e
# Print command before executing
# set -x

# TODO: Check if node, npm and gcloud are installed

source ./modules/utils.sh
source ./modules/config.sh

source ./getInputs/process-arguments.sh
handle_arguments $@

source ./working/input-variables.sh

# Read default values
source ./default-values.sh

if [[ "$PROJECT_ID_ARGS" != "[USE_DEFAULT]" ]]; then
	PROJECT_ID="$PROJECT_ID_ARGS"
fi
if [[ "$REGION_ARGS" != "[USE_DEFAULT]" ]]; then
	REGION="$REGION_ARGS"
fi
if [[ "$BUCKET_ID_ARGS" != "[USE_DEFAULT]" ]]; then
	BUCKET_ID="$BUCKET_ID_ARGS"
fi

source ./modules/check-gcp-login.sh

active_account=$(check_active_account)

if [[ -n "$active_account" ]]; then
	print_green "\nYou are currently logged in as $active_account"
else
	print_red "\nYou are not authenticated with gcloud."
	prompt_for_authentication
	active_account=$(check_active_account)
fi

get_billing_account

source ./modules/check-available-projects-quota.sh
check_available_projects_quota

source ./modules/create-project.sh
create_project

source ./modules/enable-compute-api.sh
enable_compute_api

source ./modules/update-gcloud-config.sh
update_gcloud_config

source ./modules/get-service-account.sh
get_service_account

source ./modules/delete-default-firewall-rules.sh
delete_default_firewall_rules

source ./modules/delete-default-network.sh
delete_default_network

source ./modules/create-vpc-network.sh
create_vpc_network

source ./modules/create-sub-network.sh
create_sub_network

source ./modules/create-firewall-rules.sh
create_firewall_rules

source ./modules/create-instances.sh
create_instances

# List resources for use in delete-resources.sh
source ./modules/list-resources-created.sh
list_resources_created
