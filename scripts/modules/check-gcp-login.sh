# Check for an active account using gcloud auth list
check_active_account() {
  gcloud auth list --filter=status:ACTIVE --format="value(account)"
}

prompt_for_authentication() {
  echo -e "\n"
  read -p "Would you like to authenticate now? (y/n) " prompt

  if [[ ! "$prompt" =~ ^(y|yes)$ ]]; then
    echo "Authentication skipped."
    print_red "Please authenticate with gcloud and retry."
    exit 1
  fi

  gcloud auth login

  gcloud auth list --filter=status:ACTIVE --format="value(account)"
}

get_billing_account() {
  export BILLING_ACCOUNT_ID=$(gcloud billing accounts list --format="value(ACCOUNT_ID)")
}
