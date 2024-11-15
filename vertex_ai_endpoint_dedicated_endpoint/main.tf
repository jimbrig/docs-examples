resource "google_vertex_ai_endpoint" "endpoint" {
  name         = "endpoint-name%{random_suffix}"
  display_name = "sample-endpoint"
  description  = "A sample vertex endpoint"
  location     = "us-central1"
  region       = "us-central1"
  labels       = {
    label-one = "value-one"
  }
  dedicated_endpoint_enabled = true
}

data "google_project" "project" {}