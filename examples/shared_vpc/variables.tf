variable "region" {
  default     = "europe-west1"
  description = "The default region for the provider."
}

variable "project_name" {
  description = "The default project name"
}

variable "project_id" {
  description = "The default project id"
}
variable "billing_account" {
  description = "The billing account to use"
}

variable "labels" {
  default = {
    terraform = "example_project"
  }
}
