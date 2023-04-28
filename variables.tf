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

variable "region" {
  type        = string
  description = "The region where the cluster will be created."
  default     = "europe-west1"
}

variable "project" {
  type        = string
  description = "The Google project ID."
}

variable "GCP_CREDENTIALS_JSON" {
  type        = string
  description = "The absolute path of the JSON file containing the GCP credentials to access your project."
}

variable "cluster_version" {
  type        = string
  description = "The version of Kubernetes that will run on the cluster."
  default     = "1.24*"
}

variable "worker_count" {
  type        = number
  description = "The number of worker nodes of the cluster. Default to 2"
  default     = 2
}

variable "nodes_network_cidr" {
  type        = string
  description = "The IP CIDR of the Kubernetes clusrter nodes. Default to 172.16.0.0/24"
  default     = "172.16.0.0/24"
}

variable "pod_network_cidr" {
  type        = string
  description = "The IP CIDR of the pods in the Kubernetes cluster. Default to 10.10.0.0/16"
  default     = "10.10.0.0/16"
}
