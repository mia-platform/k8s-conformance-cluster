resource "google_compute_network" "vpc_network" {
  name                    = "test-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "test-vpc-subnetwork"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
}

resource "google_compute_firewall" "allow_all_internal" {
  name    = "allow-all-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "all"
  }

  source_tags = ["k8s-cluster"]
  target_tags = ["k8s-cluster"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["control-plane"]
}

resource "google_compute_firewall" "allow_k8s" {
  name    = "allow-k8s"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["control-plane"]
}