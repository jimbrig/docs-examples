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
  tls_config {
    trust_config {
      cas_configs {
        ca_pool = google_privateca_ca_pool.ca_pool.id 
      }
    }
    ssl_principal_mapping_rules = "RULE:pattern/replacement/L,DEFAULT"
  }
}

resource "google_privateca_ca_pool" "ca_pool" {
  name = "my-ca-pool-${local.name_suffix}"
  location = "us-central1"
  tier = "ENTERPRISE"
  publishing_options {
    publish_ca_cert = true
    publish_crl = true
  }
}

data "google_project" "project" {
}
