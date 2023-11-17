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

resource "google_compute_network" "network" {
  name                    = "conformance-cluster-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "cluster-subnetwork"
  network       = google_compute_network.network.name
  ip_cidr_range = var.nodes_network_cidr
  region        = var.region

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
  }
}

resource "google_compute_firewall" "allow_iap_access" {
  name    = "allow-ssh"
  network = google_compute_network.network.name

  allow {
    protocol = "TCP"
    ports = [
      "22",
      "3389",
    ]
  }

  source_ranges = [
    "35.235.240.0/20",
  ]
  target_tags = [
    "k8s-control-plane",
  ]
}

resource "google_compute_firewall" "allow_nodes_communication" {
  name    = "allow-nodes-communication"
  network = google_compute_network.network.name

  allow {
    protocol = "all"
  }

  source_tags = [
    "k8s-control-plane",
    "k8s-worker",
  ]
  target_tags = [
    "k8s-control-plane",
    "k8s-worker",
  ]
}

resource "google_compute_firewall" "allow_node_ports" {
  name    = "allow-node-ports"
  network = google_compute_network.network.name

  allow {
    protocol = "TCP"
    ports = [
      "30000-32767",
    ]
  }

  allow {
    protocol = "UDP"
    ports = [
      "30000-32767",
    ]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
  target_tags = [
    "k8s-worker",
  ]
}

resource "google_compute_firewall" "allow_public_access" {
  name    = "allow-public-access"
  network = google_compute_network.network.name

  allow {
    protocol = "TCP"
    ports = [
      "6443",
    ]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
  target_tags = [
    "k8s-control-plane",
  ]
}
