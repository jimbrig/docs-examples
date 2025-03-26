resource "google_managed_kafka_cluster" "example" {
  cluster_id = "my-cluster-${local.name_suffix}"
  location = "us-central1"
  capacity_config {
    vcpu_count = 3
    memory_bytes = 3221225472
  }
  gcp_config {
    access_config {
      network_configs {
        subnet = "projects/${data.google_project.project.number}/regions/us-central1/subnetworks/default"
      }
    }
  }
  rebalance_config {
    mode = "AUTO_REBALANCE_ON_SCALE_UP"
  }
  labels = {
    key = "value"
  }
}

data "google_project" "project" {
}
