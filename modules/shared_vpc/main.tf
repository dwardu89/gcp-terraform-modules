resource "google_project" "host_project" {
  name            = var.host_project_name
  project_id      = var.host_project_id
  folder_id       = var.host_project_folder_id
  billing_account = var.billing_account
  skip_delete     = var.host_project_skip_delete
  labels          = var.labels
}

resource "google_project" "service_project" {
  count           = min(length(var.service_project_names), length(var.service_project_ids))
  name            = var.service_project_names[count.index]
  project_id      = var.service_project_ids[count.index]
  billing_account = var.billing_account
  skip_delete     = var.host_project_skip_delete
  labels          = var.labels
}

# API's to enable for the host project.
resource "google_project_services" "host_project" {
  project            = google_project.host_project.project_id
  services           = var.google_apis
  disable_on_destroy = false
}

resource "google_project_services" "service_project" {
  count              = length(var.service_project_ids)
  project            = var.service_project_ids[count.index]
  services           = var.google_apis
  disable_on_destroy = false
}

# Create the Shared VPC network
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = google_project.host_project.project_id
}

resource "google_compute_shared_vpc_host_project" "host_project" {
  project = google_project.host_project.project_id
}

resource "google_compute_shared_vpc_service_project" "service_project" {
  count           = length(google_project.service_project)
  host_project    = google_project.host_project.project_id
  service_project = google_project.service_project[count.index].project_id

  depends_on = ["google_compute_shared_vpc_host_project.host_project", "google_project_services.service_project", "google_compute_network.vpc"]
}
