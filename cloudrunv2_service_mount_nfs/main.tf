resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"

  location     = "us-central1"
  deletion_protection = false
  ingress      = "INGRESS_TRAFFIC_ALL"

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello:latest"
      volume_mounts {
        name       = "nfs"
        mount_path = "/mnt/nfs/filestore"
      }
    }
    vpc_access {
      network_interfaces {
        network    = "default"
        subnetwork = "default"
      }
    }

    volumes {
      name = "nfs"
      nfs {
        server    = google_filestore_instance.default.networks[0].ip_addresses[0]
        path      = "/share1"
        read_only = false
      }
    }
  }
}

resource "google_filestore_instance" "default" {
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1-b"
  tier     = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}
