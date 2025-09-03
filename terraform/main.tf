locals {
  network_interfaces = [for i, n in var.networks : {
    network     = n,
    subnetwork  = length(var.sub_networks) > i ? element(var.sub_networks, i) : null
    external_ip = length(var.external_ips) > i ? element(var.external_ips, i) : "NONE"
    }
  ]

  project = {
    id     = var.project_id
    name   = data.google_project.project.name
    number = data.google_project.project.number
  }
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# 5 VMs for the Gateway
module "norsk_gw" {
  source = "./norsk-gw/stable"

  project_id = local.project.id
  region     = var.region
  zone       = var.zone
  instance_count = var.instance_count
  machine_type = vars.machine_type
  # add a static external IP

  networks = [module.vpc.network_name]
}

# 2 VMs for the Live Simulators
module "norsk_livesim" {
  source = "./norsk-livesim/stable"

  project_id = local.project.id
  region     = var.region
  zone       = var.zone
  instance_count = var.instance_count

  networks = [module.vpc.network_name]

  # add a static external IP
}
