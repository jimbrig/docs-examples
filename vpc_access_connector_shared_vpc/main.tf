resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con-${local.name_suffix}"
  subnet {
    name = google_compute_subnetwork.custom_test.name
  }
  machine_type = "e2-standard-4"
  min_instances = 2
  max_instances = 3
}

resource "google_compute_subnetwork" "custom_test" {
  name          = "vpc-con-${local.name_suffix}"
  ip_cidr_range = "10.2.0.0/28"
  region        = "us-central1"
  network       = "default-${local.name_suffix}"
}
