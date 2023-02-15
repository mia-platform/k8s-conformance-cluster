# Copyright Mia srl
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "google_compute_instance" "worker" {
  count        = var.worker_count
  name         = "k8s-worker-${count.index + 1}"
  machine_type = "e2-standard-2"
  zone         = "${var.region}-b"
  tags = [
    "k8s-worker",
  ]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnetwork.name
    access_config {}
  }

  metadata = {
    startup-script = templatefile("${path.module}/templates/worker-startup.sh.tfpl", {
      cluster_version  = var.cluster_version
      token            = "${random_string.join_token_first_part.result}.${random_string.join_token_second_part.result}"
      control_plane_ip = "${google_compute_instance.control_plane.network_interface.0.network_ip}"
      pod_network_cidr = var.pod_network_cidr
    })
  }
}
