data "google_project" "project" {}

resource "google_compute_interconnect" "example-interconnect" {
  name                 = "example-interconnect-${local.name_suffix}"
  customer_name        = "internal_customer" # Special customer only available for Google testing.
  interconnect_type    = "DEDICATED"
  link_type            = "LINK_TYPE_ETHERNET_10G_LR"
  location             = "https://www.googleapis.com/compute/v1/${data.google_project.project.id}/global/interconnectLocations/z2z-us-east4-zone1-lciadl-a" # Special location only available for Google testing.
  requested_link_count = 1
  admin_enabled        = true
  description          = "example description"
  macsec_enabled       = false
  noc_contact_email    = "user@example.com"
  requested_features   = []
  labels = {
    mykey = "myvalue"
  }
}
