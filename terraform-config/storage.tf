resource "google_storage_bucket" "jsd-bucket" {
  name                        = local.storage_bucket_name
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "docker_script" {
  name   = "docker-startup-script.sh"
  bucket = google_storage_bucket.jsd-bucket.name
  source = "../vm-startup-scripts/docker-startup-script.sh"
}

resource "google_storage_bucket_object" "sonarqube_script" {
  name   = "sonarqube-startup-script.sh"
  bucket = google_storage_bucket.jsd-bucket.name
  source = "../vm-startup-scripts/sonarqube-startup-script.sh"
}
resource "google_storage_bucket_object" "jenkins_script" {
  name   = "jenkins-startup-script.sh"
  bucket = google_storage_bucket.jsd-bucket.name
  source = "../vm-startup-scripts/jenkins-startup-script.sh"
}

