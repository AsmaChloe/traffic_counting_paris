
variable "credentials" {
    description = "My Service Account Credentials"
    default = "./../keys/de-traffic-couting-paris-d53cfd26097d.json"
}

variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "traffic-counter"
}

variable "container_cpu" {
  description = "Container cpu"
  default     = "2000m"
}

variable "container_memory" {
  description = "Container memory"
  default     = "2G"
}

variable "project_id" {
  type        = string
  description = "The name of the project"
  default     = "de-traffic-couting-paris"
}

variable "region" {
  type        = string
  description = "The default compute region"
  default     = "europe-west9"
}

variable "zone" {
  type        = string
  description = "The default compute zone"
  default     = "europe-west9-a"
}

variable "repository" {
  type        = string
  description = "The name of the Artifact Registry repository to be created"
  default     = "de-traffic-couting-paris"
}

variable "database_user" {
  type        = string
  description = "The username of the Postgres database."
  sensitive   = true
}

variable "database_password" {
  type        = string
  description = "The password of the Postgres database."
  sensitive   = true
}

variable "docker_image" {
  type        = string
  description = "The docker image to deploy to Cloud Run."
  default     = "mageai/mageai:latest"
}

variable "domain" {
  description = "Domain name to run the load balancer on. Used if `ssl` is `true`."
  type        = string
  default     = ""
}

variable "ssl" {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
  default     = false
}