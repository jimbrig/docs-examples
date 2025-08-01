resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  launch_stage = "BETA"
  template {
    template {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/job"
      }
      node_selector {
        accelerator = "nvidia-l4"
      }
      gpu_zonal_redundancy_disabled = true
    }
  }
}
