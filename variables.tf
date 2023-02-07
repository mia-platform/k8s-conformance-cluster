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
  default     = "1.24.10"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster."
  default     = "k8s-conformance-cluster"
}

variable "pod_network_cidr" {
  type        = string
  description = "The IP CIDR of the pods in the Kubernetes cluster."
}