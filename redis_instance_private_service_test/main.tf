// This example assumes this network already exists.
// The API creates a tenant network per network authorized for a
// Redis instance and that network is not deleted when the user-created
// network (authorized_network) is deleted, so this prevents issues
// with tenant network quota.
// If this network hasn't been created and you are using this example in your
// config, add an additional network resource or change
// this from "data"to "resource"
data "google_compute_network" "redis-network" {
  name = "redis-test-network-${local.name_suffix}"
}

resource "google_redis_instance" "cache" {
  name           = "private-cache-${local.name_suffix}"
  tier           = "STANDARD_HA"
  memory_size_gb = 1

  location_id             = "us-central1-a"
  alternative_location_id = "us-central1-f"

  authorized_network = data.google_compute_network.redis-network.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version     = "REDIS_7_2"
  display_name      = "Terraform Test Instance"

  lifecycle {
    prevent_destroy = false
  }
}
