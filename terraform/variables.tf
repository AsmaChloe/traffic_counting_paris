variable "credentials" {
    description = "My Service Account Credentials"
    default = "./../keys/de-traffic-couting-paris-48fce94e7c3f.json"
}

variable "project" {
    description = "Project ID"
    default = "de-traffic-couting-paris"
}

variable "data-lake-bucket-name" {
    description = "Data lake bucket name"
    default = "de-traffic-couting-paris-data-late-bucket"
}