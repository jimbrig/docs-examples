resource "google_compute_region_health_check" "https-region-health-check" {
  provider    = google-beta
  name        = "https-region-health-check-${local.name_suffix}"
  description = "Health check via https"

  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 4
  unhealthy_threshold = 5

  https_health_check {
    port_name          = "health-check-port"
    port_specification = "USE_NAMED_PORT"
    host               = "1.2.3.4"
    request_path       = "/mypath"
    proxy_header       = "NONE"
    response           = "I AM HEALTHY"
  }
}
