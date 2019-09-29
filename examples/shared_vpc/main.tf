provider "google" {
  region  = var.region
  version = "~> 2.15.0"
}


module "shared_vpc" {
  source                = "../../modules/shared_vpc"
  vpc_name              = "Test VPC Name"
  host_project_name     = var.project_name
  host_project_id       = var.project_id
  service_project_names = ["service-project-1", "service-project-2"]
  service_project_ids   = ["service-project-1", "service-project-2"]
  billing_account       = var.billing_account
  labels                = var.labels
}


