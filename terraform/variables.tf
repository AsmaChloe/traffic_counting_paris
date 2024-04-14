variable "credentials" {
    description = "My Service Account Credentials"
}

variable "project" {
    description = "Project ID"
    default = "de-traffic-couting-paris"
}

variable "data-lake-bucket-name" {
    description = "Data lake bucket name"
    default = "de-traffic-couting-paris-data-late-bucket"
}

variable "location" {
  description = "Location"
  default = "EUROPE-WEST9"
}