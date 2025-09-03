module "compute" {
  source = "../../compute/stable"

  project_id           = var.project_id
  region               = var.region
  instance_group_name  = "norsk-gw-mig"
  base_instance_name   = "norsk-gw"
  target_size          = var.instance_count
  machine_type         = var.machine_type
  source_image         = var.source_image
  boot_disk_type       = var.boot_disk_type
  boot_disk_size       = var.boot_disk_size
  tags                 = ["${var.goog_cm_deployment_name}-deployment", "livesim"]

  networks             = var.networks
  sub_networks         = var.sub_networks
  external_ips         = var.external_ips

  metadata = {
    norsk-studio-admin-password = random_password.admin.result
    deploy_domain_name          = var.domain_name
    deploy_certbot_email        = var.certbot_email
    google-logging-enable       = "0"
    google-monitoring-enable    = "0"
  }

  named_ports = [{
    name = "https"
    port = 443
  }]
}

resource "random_password" "admin" {
  length  = 22
  special = false
}
