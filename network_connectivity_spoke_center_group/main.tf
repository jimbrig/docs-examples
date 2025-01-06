resource "google_compute_network" "network" {
  name                    = "tf-net"
  auto_create_subnetworks = false
}

resource "google_network_connectivity_hub" "star_hub" {
  name = "hub-basic-${local.name_suffix}"
  preset_topology = "STAR"
}

resource "google_network_connectivity_group" "center_group" { 
  name = "center"  # (default , center , edge)
  hub  = google_network_connectivity_hub.star_hub.id
  auto_accept {
    auto_accept_projects = [
      "foo%{random_suffix}", 
      "bar%{random_suffix}", 
    ]
  }
}

resource "google_network_connectivity_spoke" "primary"  {
  name = "vpc-spoke-${local.name_suffix}"
  location = "global"
  description = "A sample spoke"
  labels = {
    label-one = "value-one"
  }
  hub = google_network_connectivity_hub.star_hub.id
  group  = google_network_connectivity_group.center_group.id

  linked_vpc_network {
    uri = google_compute_network.network.self_link
  }
}