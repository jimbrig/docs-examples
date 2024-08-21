resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"

  location     = "us-central1"
  deletion_protection = false
  launch_stage = "BETA"

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"

    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      volume_mounts {
        name       = "bucket"
        mount_path = "/var/www"
      }
    }

    volumes {
      name = "bucket"
      gcs {
        bucket    = google_storage_bucket.default.name
        read_only = false
      }
    }
  }
}

resource "google_storage_bucket" "default" {
    name     = "cloudrun-service-${local.name_suffix}"
    location = "US"
}
