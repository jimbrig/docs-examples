resource "google_compute_url_map" "urlmap" {
  name        = "urlmap-${local.name_suffix}"
  description = "a description"

  default_service = google_compute_backend_service.example.id

  default_custom_error_response_policy {
    error_response_rule {
      match_response_codes = ["5xx"] # Catch all 5xx responses
      path = "/internal_error.html" # Serve /internal_error.html from error service
      override_response_code = 502
    }
    error_service = google_compute_backend_bucket.error.id
  }

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "mysite"
  }

  path_matcher {
    name            = "mysite"
    default_service = google_compute_backend_service.example.id

    default_custom_error_response_policy {
      error_response_rule {
        match_response_codes = ["4xx", "5xx"] # Catch all 4xx and 5xx responses
        path = "/login_error.html" # Serve /login_error.html from the error service
        override_response_code = 404
      }
      error_response_rule {
        match_response_codes = ["503"] # Catch only 503 responses
        path = "/bad_gateway.html" # Serve /bad_gateway.html from the error service
        override_response_code = 502
      }
      error_service = google_compute_backend_bucket.error.id
    }

    path_rule {
      paths   = ["/private/*"]
      service = google_compute_backend_service.example.id

      custom_error_response_policy {
        error_response_rule {
          match_response_codes = ["4xx"] # Catch all 4xx responses under /private/*
          path = "/login.html" # Serve /login.html from the error service
          override_response_code = 401
        }
        error_service = google_compute_backend_bucket.error.id
      }
    }
  }
}

resource "google_compute_backend_service" "example" {
  name        = "login-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_backend_bucket" "error" {
  name        = "error-backend-bucket-${local.name_suffix}"
  bucket_name = google_storage_bucket.error.name
  enable_cdn  = true
}

resource "google_storage_bucket" "error" {
  name        = "static-asset-bucket-${local.name_suffix}"
  location    = "US"
}
