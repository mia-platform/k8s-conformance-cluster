resource "google_compute_instance" "worker" {
  count        = 2
  name         = "k8s-worker-${count.index + 1}"
  machine_type = "e2-standard-2"
  zone         = "${var.region}-b"
  tags         = ["k8s-cluster"]

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
    startup-script = "${data.template_file.worker_startup.rendered}"
  }

}

data "template_file" "worker_startup" {
  template = file("${path.root}/templates/worker-startup.sh")
  vars = {
    cluster_version  = var.cluster_version
    token            = "${random_string.join_token_first_part.result}.${random_string.join_token_second_part.result}"
    master_ip        = "${google_compute_instance.master.network_interface.0.network_ip}"
    pod_network_cidr = var.pod_network_cidr
  }
}