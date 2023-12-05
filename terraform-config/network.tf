module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 8.0"

  project_id   = data.terraform_remote_state.remote.outputs.poc_project_id
  network_name = var.network_name

  subnets = [{
    subnet_name   = "${var.subnet_name}"
    subnet_ip     = "10.10.20.0/24"
    subnet_region = var.region
  }]
}

module "firewall" {
  source = "terraform-google-modules/network/google//modules/firewall-rules"

  project_id   = data.terraform_remote_state.remote.outputs.poc_project_id
  network_name = module.vpc.network_name

  rules = [
    {
      name          = "allow-jenkins-module"
      description   = "Allow jenkins traffic"
      direction     = "INGRESS"
      priority      = 1000
      action        = "ALLOW"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["${var.jenkins_network_tag}"]
      allow = [{
        protocol = "tcp"
        ports    = ["8080"]
      }]
    },
    {
      name          = "allow-sonarqube"
      description   = "Allow sonarqube traffic"
      direction     = "INGRESS"
      priority      = 1000
      action        = "ALLOW"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["${var.sonarqube_network_tag}"]
      allow = [{
        protocol = "tcp"
        ports    = ["9000"]
      }]
    },
    {
      name          = "allow-docker"
      description   = "Allow docker traffic"
      direction     = "INGRESS"
      priority      = 1000
      action        = "ALLOW"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["${var.docker_network_tag}"]
      allow = [{
        protocol = "tcp"
        ports    = ["9000"]
      }]
    },
    {
      name          = "allow-ssh"
      description   = "Allow SSH traffic"
      direction     = "INGRESS"
      priority      = 65534
      action        = "ALLOW"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["ssh"]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
    },
    {
      name          = "allow-internal"
      description   = "Allow Internal traffic"
      direction     = "INGRESS"
      priority      = 65534
      action        = "ALLOW"
      source_ranges = ["10.128.0.0/9"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        },
        {
          protocol = "icmp"
        }
      ]
    },
    {
      name          = "allow-icmp"
      description   = "Allow icmp traffic"
      direction     = "INGRESS"
      priority      = 65534
      action        = "ALLOW"
      source_ranges = ["0.0.0.0/0"]
      allow = [{
        protocol = "icmp"
      }]
    },
    {
      name          = "allow-rdp"
      description   = "Allow rdp traffic"
      direction     = "INGRESS"
      priority      = 65534
      action        = "ALLOW"
      source_ranges = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["3389"]
      }]
    }
  ]
}
