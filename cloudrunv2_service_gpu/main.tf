resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      resources {
        limits = {
          "cpu" = "4"
          "memory" = "16Gi"
          "nvidia.com/gpu" = "1"
        }
        startup_cpu_boost = true
      }
    }
    node_selector {
      accelerator = "nvidia-l4"
    }
    gpu_zonal_redundancy_disabled = true
    scaling {
      max_instance_count = 1
    }
  }
}
