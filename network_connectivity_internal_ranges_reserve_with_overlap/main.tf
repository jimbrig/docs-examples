resource "google_network_connectivity_internal_range" "default" {
  name    = "overlap-range-${local.name_suffix}"
  description = "Test internal range"
  network = google_compute_network.default.id
  usage   = "FOR_VPC"
  peering = "FOR_SELF"
  ip_cidr_range = "10.0.0.0/30"

  overlaps = [
    "OVERLAP_EXISTING_SUBNET_RANGE"
  ]

  depends_on = [
    google_compute_subnetwork.default
  ]
}

resource "google_compute_network" "default" {
  name                    = "internal-ranges-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "overlapping-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.id
}
