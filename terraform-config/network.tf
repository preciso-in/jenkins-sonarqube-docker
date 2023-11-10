resource "google_compute_network" "vpc_network" {
  project                 = local.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

// Optional argument "project" is required in block because we create project
// in our TF config and hence region, project and other details 
// which are specified are not present in it.

resource "google_compute_subnetwork" "jsd_subnetwork" {
  name          = var.subnet_name
  ip_cidr_range = "10.0.20.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  project       = local.project_id
}


resource "google_compute_firewall" "allow_icmp" {
  name          = "allow-icmp"
  direction     = "INGRESS"
  priority      = 65534
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }
  project = local.project_id
}

resource "google_compute_firewall" "allow_internal" {
  name          = "allow-internal"
  direction     = "INGRESS"
  priority      = 65534
  network       = google_compute_network.vpc_network.id
  source_ranges = ["10.128.0.0/9"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
  project = local.project_id
}

resource "google_compute_firewall" "allow_rdp" {
  name          = "allow-rdp"
  direction     = "INGRESS"
  priority      = 65534
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  project = local.project_id
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "allow-ssh"
  direction     = "INGRESS"
  priority      = 65534
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  project = local.project_id
}

resource "google_compute_firewall" "allow_jenkins" {
  name          = "allow-jenkins"
  direction     = "INGRESS"
  priority      = 1000
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  target_tags = ["${var.jenkins_network_tag}"]
  project     = local.project_id
}

resource "google_compute_firewall" "allow_sonarqube" {
  name          = "allow-sonarqube"
  direction     = "INGRESS"
  priority      = 1000
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }
  target_tags = ["${var.sonarqube_network_tag}"]
  project     = local.project_id
}

resource "google_compute_firewall" "allow_docker" {
  name          = "allow-docker"
  direction     = "INGRESS"
  priority      = 1000
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["8085"]
  }
  target_tags = ["${var.docker_network_tag}"]
  project     = local.project_id
}
