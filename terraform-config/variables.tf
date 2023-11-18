resource "random_id" "random" {
  byte_length = 4
}

variable "region" {
  default     = "us-central1"
  description = "Region where the Project will be created"
  type        = string
}

variable "network_name" {
  default = "jsd-nw"
  type    = string
}

variable "subnet_name" {
  default = "jsd-subnet"
  type    = string
}

variable "storage_bucket_name" {
  default = "jsd-storage-bucket"
  type    = string
}

variable "instance_template_name" {
  default = "jsd-instance-template"
  type    = string
}

variable "jenkins_instance_name" {
  default = "ci-server"
  type    = string
}

variable "docker_instance_name" {
  default = "container-server"
  type    = string
}

variable "sonarqube_instance_name" {
  default = "code-scanner-server"
  type    = string
}

variable "jenkins_network_tag" {
  default = "ci-server"
  type    = string
}

variable "sonarqube_network_tag" {
  default = "scanner-server"
  type    = string
}

variable "docker_network_tag" {
  default = "container-server"
  type    = string
}

variable "billing_account_id" {
  description = "Billing Account ID to be set by running gcloud command in Shell"
  default     = "016376-64BEEB-494695"
  type        = string
}

locals {
  storage_bucket_name = "${var.storage_bucket_name}-${random_id.random.hex}"
}
