# Create a VPC
resource "google_compute_network" "default" {
  name = "example-network-${local.name_suffix}"
}

# Create an IP address
resource "google_compute_global_address" "default" {
  name          = "psa-range-${local.name_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.default.id
}

# Create a private connection
resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.default.name]
}

# Enable VPC-SC on the producer network
resource "google_service_networking_vpc_service_controls" "default" {
  network    = google_compute_network.default.name
  service    = "servicenetworking.googleapis.com"
  enabled    = true
  depends_on = [google_service_networking_connection.default]
}
