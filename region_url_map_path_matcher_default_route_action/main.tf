resource "google_compute_region_url_map" "regionurlmap" {
  region = "us-central1"

  name        = "regionurlmap-${local.name_suffix}"
  description = "a description"
  default_service = google_compute_region_backend_service.home.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"

    default_route_action {
      cors_policy {
        disabled = false
        allow_credentials = true
        allow_headers = [
          "foobar"
        ]
        allow_methods = [
          "GET",
          "POST",
        ]
        allow_origins = [
          "example.com"
        ]
        expose_headers = [
          "foobar"
        ]
        max_age = 60
      } 
      fault_injection_policy {
        abort {
          http_status = 500
          percentage  = 0.5
        }
        delay {
          fixed_delay {
            nanos   = 500
            seconds = 0
          }
          percentage = 0.5
        }
      }
      request_mirror_policy {
        backend_service = google_compute_region_backend_service.home.id
      }
      retry_policy {
        num_retries = 3
        per_try_timeout {
          nanos   = 500
          seconds = 0
        }
        retry_conditions = [
          "5xx",
          "gateway-error",
        ]
      }
      timeout {
        nanos   = 500
        seconds = 0
      }
      url_rewrite {
        host_rewrite          = "dev.example.com"
        path_prefix_rewrite   = "/v1/api/"
      }
      weighted_backend_services {
        backend_service = google_compute_region_backend_service.home.id
        header_action {
          request_headers_to_add {
            header_name  = "foo-request-1"
            header_value = "bar"
            replace      = true
          }
          request_headers_to_add {
            header_name  = "foo-request-2"
            header_value = "bar"
            replace      = true
          }
          request_headers_to_remove = ["fizz"]
          response_headers_to_add {
            header_name  = "foo-response-1"
            header_value = "bar"
            replace      = true
          }
          response_headers_to_add {
            header_name  = "foo-response-2"
            header_value = "bar"
            replace      = true
          }
          response_headers_to_remove = ["buzz"]
        }
        weight = 100
      }
      weighted_backend_services {
        backend_service = google_compute_region_backend_service.login.id
        header_action {
          request_headers_to_add {
            header_name  = "foo-request-1"
            header_value = "bar"
            replace      = true
          }
          request_headers_to_add {
            header_name  = "foo-request-2"
            header_value = "bar"
            replace      = true
          }
          request_headers_to_remove = ["fizz"]
          response_headers_to_add {
            header_name  = "foo-response-1"
            header_value = "bar"
            replace      = true
          }
          response_headers_to_add {
            header_name  = "foo-response-2"
            header_value = "bar"
            replace      = true
          }
          response_headers_to_remove = ["buzz"]
        }
        weight = 200
      }
    }

    path_rule {
      paths   = ["/home"]
      service = google_compute_region_backend_service.home.id
    }

    path_rule {
      paths   = ["/login"]
      service = google_compute_region_backend_service.login.id
    }
  }

  test {
    service = google_compute_region_backend_service.home.id
    host    = "hi.com"
    path    = "/home"
  }
}

resource "google_compute_region_backend_service" "login" {
  region = "us-central1"

  name        = "login-${local.name_suffix}"
  protocol    = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_backend_service" "home" {
  region = "us-central1"

  name        = "home-${local.name_suffix}"
  protocol    = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_health_check" "default" {
  region = "us-central1"

  name               = "health-check-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1
  http_health_check {
    port         = 80
    request_path = "/"
  }
}
