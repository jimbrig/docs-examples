resource "google_compute_url_map" "urlmap" {
  name        = "urlmap-${local.name_suffix}"
  description = "a description"
  default_service = google_compute_backend_service.home.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name = "allpaths"
    default_service = google_compute_backend_service.home.id

    path_rule {
      paths   = ["/home"]
      route_action {
        cors_policy {
          allow_credentials = true
          allow_headers = ["Allowed content"]
          allow_methods = ["GET"]
          allow_origin_regexes = ["abc.*"]
          allow_origins = ["Allowed origin"]
          expose_headers = ["Exposed header"]
          max_age = 30
          disabled = false
        }
        weighted_backend_services {
          backend_service = google_compute_backend_service.home.id
          weight = 400
          header_action {
            request_headers_to_remove = ["RemoveMe"]
            request_headers_to_add {
              header_name = "AddMe"
              header_value = "MyValue"
              replace = true
            }
            response_headers_to_remove = ["RemoveMe"]
            response_headers_to_add {
              header_name = "AddMe"
              header_value = "MyValue"
              replace = false
            }
          }
        }
        max_stream_duration {
          nanos   = 500000
          seconds = 9
        }
      }
    }
  }

  test {
    service = google_compute_backend_service.home.id
    host    = "hi.com"
    path    = "/home"
  }
}

resource "google_compute_backend_service" "home" {
  name        = "home-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_health_check.default.id]
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
}

resource "google_compute_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
