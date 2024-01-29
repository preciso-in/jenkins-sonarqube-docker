#!/bin/bash
trap 'echo "${BASH_SOURCE[0]}: line ${LINENO}: status ${?}: user ${USER}: func ${FUNCNAME[0]}"' ERR

################################################################################
#               Create App Resources on GCP with GCloud CLI                    #
#                                                                              #
# This script deletes Google Cloud resources created by this repo              #
#                                                                              #
# Requirements:                                                                #
# - gcloud                                                                     #
#                                                                              #
# Usage: 																																		   #
# ./scripts/delete-resources.sh  																							 #
#                                                                              #
# Change History                                                               #
# 20/01/2024  Nilesh Parkhe   Working script that deletes Networks,            #
#                             Firewall rules and VM Servers that are           #
#                             created by create-resources.sh                   #
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

script_dir=$(dirname "$(realpath "$0")")
cd "$script_dir"

# TODO: Check if node, npm and gcloud are installed

source ./modules/utils.sh

#TODO: Save name of computed variables used by create-resources.sh
source ./working/created-resource-names.sh

source ./modules/check-gcp-login.sh

active_account=$(check_active_account)

if [[ -n "$active_account" ]]; then
	print_green "\nYou are currently logged in as $active_account"
else
	print_red "\nYou are not authenticated with gcloud."
	prompt_for_authentication
	active_account=$(check_active_account)
fi

source ./modules/delete-instances.sh
delete_instances

source ./modules/delete-instance-templates.sh
delete_instance_templates

source ./modules/delete-startup-scripts.sh
delete_startup_scripts

source ./modules/delete-bucket.sh
delete_bucket

source ./modules/delete-firewall-rules.sh
delete_firewall_rules

source ./modules/delete-subnetwork.sh
delete_subnets

source ./modules/delete-network.sh
delete_network

source ./modules/delete-project.sh
delete_project
