provider "google" {
}


resource "google_project" "jsd" {
  name                = "Jenkins-Sonarqube-Docker"
  project_id          = local.project_id
  auto_create_network = false
  billing_account     = var.billing_account_id
}

resource "random_id" "random" {
  byte_length = 4
}


resource "google_project_service" "compute_API" {
  service = "compute.googleapis.com"
  project = local.project_id

  depends_on = [google_project.jsd]
}

data "google_project" "current" {
  project_id = local.project_id
}
