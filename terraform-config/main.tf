terraform {
  backend "gcs" {
    bucket = "poc-tfstate-bucket-54d86196"
    prefix = "terraform/state"
  }
}

data "terraform_remote_state" "remote" {
  backend = "gcs"
  config = {
    bucket = "admin-tfstate-bucket"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = data.terraform_remote_state.remote.outputs.poc_project_id
  region  = var.region
}


