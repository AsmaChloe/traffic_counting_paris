terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = "europe-west9"
  credentials = var.credentials
}


# Bucket creation
resource "google_storage_bucket" "data-lake-bucket" {
  name          = var.data-lake-bucket-name
  location      = "EUROPE-WEST9"

  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  force_destroy = true
}