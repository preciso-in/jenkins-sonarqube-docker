
resource "google_compute_instance_from_template" "jenkins_tpl" {
  name = var.jenkins_instance_name
  zone = "${var.region}-a"

  source_instance_template = google_compute_instance_template.jsd_instance_template.self_link_unique

  tags    = ["${var.jenkins_network_tag}"]
  project = local.project_id
  metadata = {
    startup-script-url = "gs://${google_storage_bucket_object.jenkins_script.bucket}/${google_storage_bucket_object.jenkins_script.name}"
  }
}


resource "google_compute_instance_from_template" "sonarqube_tpl" {
  name = var.sonarqube_instance_name
  zone = "${var.region}-a"

  source_instance_template = google_compute_instance_template.jsd_instance_template.self_link_unique

  tags    = ["${var.sonarqube_network_tag}"]
  project = local.project_id
  metadata = {
    startup-script-url = "gs://${google_storage_bucket_object.sonarqube_script.bucket}/${google_storage_bucket_object.sonarqube_script.name}"
  }
}


resource "google_compute_instance_from_template" "docker_tpl" {
  name = var.docker_instance_name
  zone = "${var.region}-a"

  source_instance_template = google_compute_instance_template.jsd_instance_template.self_link_unique

  tags    = ["${var.docker_network_tag}"]
  project = local.project_id
  metadata = {
    startup-script-url = "gs://${google_storage_bucket_object.docker_script.bucket}/${google_storage_bucket_object.docker_script.name}"
  }
}

resource "google_compute_instance_from_template" "test_tpl" {
  name = "test-instance"
  zone = "${var.region}-a"

  source_instance_template = google_compute_instance_template.jsd_instance_template.self_link_unique

  tags    = ["${var.docker_network_tag}"]
  project = local.project_id
  metadata = {
    a = "b"
  }
}
resource "google_compute_instance_from_template" "test_tpl1" {
  name = "test-instance1"
  zone = "${var.region}-a"

  source_instance_template = google_compute_instance_template.jsd_instance_template.self_link_unique

  tags    = ["${var.docker_network_tag}"]
  project = local.project_id
}
