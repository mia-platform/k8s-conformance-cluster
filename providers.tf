provider "google" {
  credentials = var.GCP_CREDENTIALS_JSON
  project     = var.project
  region      = var.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 5.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">=3.1"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
  }

  required_version = ">= 0.14"
}
