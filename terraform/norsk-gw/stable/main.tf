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

  startup_script = <<-EOT
      #!/bin/bash
      set -e # Exit immediately if a command exits with a non-zero status.

      echo ">>> Starting startup script..."

     # Install Norsk License & startup

     gsutil cp gs://ghacks-media-on-gcp-private/license.json /var/norsk-studio/norsk-studio-docker/secrets/license.json
     systemctl restart norsk.service

      echo ">>> Startup script finished."
    EOT

  named_ports = [{
    name = "https"
    port = 443
  }]
}

resource "random_password" "admin" {
  length  = 22
  special = false
}
