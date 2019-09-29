variable "region" {
  description = "The region to use"
  type        = string
}

variable "host_project_name" {
  description = "The name of the host project."
  type        = string
}

variable "host_project_id" {
  description = "The id of the host project."
  type        = string
}

variable "billing_account" {
  default     = -1
  description = "The billing account used for the project."
  type        = string
}

variable "host_project_skip_delete" {
  default     = true
  description = " Skip deletion of the host project if the resource is removed from terraform."
  type        = bool
}

variable "service_project_ids" {
  default     = []
  description = "A list of service project ids"
  type        = list
}

variable "service_project_names" {
  default     = []
  description = "A list of service projects names"
  type        = list
}

variable "google_apis" {
  default     = ["compute.googleapis.com", "container.googleapis.com"]
  description = "A list of Google APIs to enable in the project"
  type        = list
}

variable "vpc_name" {
  description = "The name of the VPC to create"
  type        = string
}

variable "vpc_subnet_prefix" {
  default     = "10.10.0.0/15"
  description = "The subnet prefix to use"
  type        = string
}

variable "external_ip_address_count" {
  default     = 1
  description = "The amount of external IP Addresses to create for the NAT gateway."
  type        = number
}

variable "labels" {
  default     = {}
  description = "Labels to apply to the resources"
  type        = map
}
