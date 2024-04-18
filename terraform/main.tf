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
  location      = var.location

  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  force_destroy = true
}

resource "google_bigquery_dataset" "traffic_counting" {
  dataset_id = "traffic_counting"
  location   = var.location

  delete_contents_on_destroy = true
}

resource "google_bigquery_table" "traffic_counting_data_raw" {
  dataset_id = google_bigquery_dataset.traffic_counting.dataset_id
  table_id   = "traffic_counting_data_raw"

  deletion_protection=false

  time_partitioning {
    type  = "DAY"
    field = "t_1h"
  }

  clustering = [ "libelle" ]

  schema =<<EOF
[ 
    {
      "name" : "iu_ac",
      "type" : "INT64"
    },
    {
      "name" : "libelle",
      "type" : "STRING"
    },
    {
      "name" : "t_1h",
      "type" : "TIMESTAMP"
    },
    {
      "name" : "q",
      "type" : "FLOAT64"
    },
    {
      "name" : "k",
      "type" : "FLOAT64"
    },
    {
      "name" : "etat_trafic",
      "type" : "STRING"
    },
    {
      "name" : "iu_nd_amont",
      "type" : "INT64"
    },
    {
      "name" : "libelle_nd_amont",
      "type" : "STRING"
    },
    {
      "name" : "iu_nd_aval",
      "type" : "INT64"
    },
    {
      "name" : "libelle_nd_aval",
      "type" : "STRING"
    },
    {
      "name" : "etat_barre",
      "type" : "STRING"
    },
    {
      "name" : "date_debut",
      "type" : "TIMESTAMP"
    },
    {
      "name" : "date_fin",
      "type" : "TIMESTAMP"
    },
    {
      "name" : "geo_point_2d",
      "type" : "STRING"
    },
    {
      "name" : "geo_shape",
      "type" : "STRING"
    }
  ]
  EOF

  
}
