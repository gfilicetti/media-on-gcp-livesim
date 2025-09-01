# Default VPC
module "vpc" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "~> 10.0.0"

  project_id              = local.project.id
  network_name            = "vpc-livesim"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = true
}

# General Firewall Rules

# Punch a hole for internal VM to VM traffic
resource "google_compute_firewall" "fwr_allow_internal" {
  name          = "fwr-ingress-allow-internal"
  network       = module.vpc.network_self_link
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
}

# Punch a hole for IAP traffic
resource "google_compute_firewall" "fwr_allow_iap" {
  name          = "fwr-ingress-allow-iap"
  network       = module.vpc.network_self_link
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "fwr_ssh" {
  name    = "fwr-ingress-allow-ssh"
  network = module.vpc.network_self_link

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "fwr_http" {
  name    = "fwr-ingress-allow-http"
  network = module.vpc.network_self_link

  allow {
    ports    = ["80", "443"]
    protocol = "tcp"
  }

  source_ranges = ["0.0.0.0/0"]
}

### NOTE: These are Norsk specific firewall rules from here to the bottom
resource "google_compute_firewall" "fwr_tcp_3478" {
  count = var.enable_tcp_3478 ? 1 : 0

  name    = "fwr-allow-norsk-tcp-3478"
  network = element(var.networks, 0)

  allow {
    ports    = ["3478"]
    protocol = "tcp"
  }

  source_ranges = compact([for range in split(",", var.tcp_3478_source_ranges) : trimspace(range)])

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}

resource "google_compute_firewall" "fwr_udp_3478" {
  count = var.enable_udp_3478 ? 1 : 0

  name    = "fwr-allow-norsk-udp-3478"
  network = element(var.networks, 0)

  allow {
    ports    = ["3478"]
    protocol = "udp"
  }

  source_ranges = compact([for range in split(",", var.udp_3478_source_ranges) : trimspace(range)])

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}

resource "google_compute_firewall" "fwr_udp_5001" {
  count = var.enable_udp_5001 ? 1 : 0

  name    = "fwr-allow-norsk-udp-5001"
  network = element(var.networks, 0)

  allow {
    ports    = ["5001"]
    protocol = "udp"
  }

  source_ranges = compact([for range in split(",", var.udp_5001_source_ranges) : trimspace(range)])

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}
