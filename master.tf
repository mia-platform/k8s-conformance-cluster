resource "google_compute_instance" "master" {
  name         = "k8s-control-plane"
  machine_type = "e2-standard-2"
  zone         = "${var.region}-b"
  tags         = ["k8s-cluster", "control-plane"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnetwork.name
    access_config {}
  }

  metadata = {
    startup-script = "${data.template_file.master_startup.rendered}"
  }

}

data "template_file" "master_startup" {
  template = file("${path.root}/templates/master-startup.sh")
  vars = {
    cluster_version  = var.cluster_version
    token            = "${random_string.join_token_first_part.result}.${random_string.join_token_second_part.result}"
    pod_network_cidr = var.pod_network_cidr
  }
}

resource "random_string" "join_token_first_part" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "join_token_second_part" {
  length  = 16
  special = false
  upper   = false
}