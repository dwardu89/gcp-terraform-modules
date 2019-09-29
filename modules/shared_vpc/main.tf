resource "google_project" "host_project" {
  name            = var.host_project_name
  project_id      = var.host_project_id
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

# Create the VPC network
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = google_project.host_project.project_id
}

# Create a subnetwork in the VPC
resource "google_compute_subnetwork" "vpc_subnetwork" {
  name                     = "k8s-${var.region}"
  ip_cidr_range            = cidrsubnet(var.vpc_subnet_prefix, 8, 0)
  region                   = var.region
  network                  = "${google_compute_network.vpc.self_link}"
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-${var.region}-pods"
    ip_cidr_range = cidrsubnet(var.vpc_subnet_prefix, 1, 1)
  }

  secondary_ip_range {
    range_name    = "k8s-${var.region}-services"
    ip_cidr_range = cidrsubnet(var.vpc_subnet_prefix, 3, 2)
  }
}

# Set the host project to be the host in the Shared VPC
resource "google_compute_shared_vpc_host_project" "host_project" {
  project = google_project.host_project.project_id
}

# Set the service projects to be service projects so they can utilize the Shared VPC
resource "google_compute_shared_vpc_service_project" "service_project" {
  count           = length(google_project.service_project)
  host_project    = google_project.host_project.project_id
  service_project = google_project.service_project[count.index].project_id

  depends_on = ["google_compute_shared_vpc_host_project.host_project", "google_project_services.service_project", "google_compute_network.vpc"]
}

# Cloud NAT gateway setup for the subnetwork
resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.vpc_subnetwork.region
  network = google_compute_network.vpc.self_link
  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "address" {
  count  = var.external_ip_address_count
  name   = "nat-${count.index}"
  region = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.address.*.self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
