resource "google_storage_bucket" "jsd-bucket" {
  name          = local.storage_bucket_name
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
  project                     = local.project_id
}


resource "google_storage_bucket_object" "docker_script" {
  name   = "docker-startup-script.sh"
  bucket = google_storage_bucket.jsd-bucket.name
  source = "../startup-scripts/docker-startup-script.sh"
}

resource "google_storage_bucket_object" "sonarqube_script" {
  name   = "sonarqube-startup-script.sh"
  bucket = google_storage_bucket.jsd-bucket.name
  source = "../startup-scripts/sonarqube-startup-script.sh"
}
resource "google_storage_bucket_object" "jenkins_script" {
  name   = "jenkins-startup-script.sh"
  bucket = google_storage_bucket.jsd-bucket.name
  source = "../startup-scripts/jenkins-startup-script.sh"
}

