resource "google_network_services_http_route" "default" {
  name                   = "my-http-route-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description             = "my description"
  hostnames               = ["example"]
  rules                   {
    action {
      fault_injection_policy {
       delay {
         fixed_delay = "1s"
         percentage = 1
       }
       abort {
         http_status = 500
         percentage = 1
       }
     }
      url_rewrite {
        path_prefix_rewrite = "new-prefix"
        host_rewrite = "new-host"
      }
      retry_policy {
          retry_conditions = ["server_error"]
          num_retries = 1
          per_try_timeout =  "1s"
      }
      request_mirror_policy {
        destination {
          service_name = "new"
          weight = 1
        }
      }
      cors_policy {
        allow_origins = ["example"]
        allow_methods = ["GET", "PUT"]
        allow_headers = ["version", "type"]
        expose_headers = ["version", "type"]
        max_age = "1s"
        allow_credentials = true
        disabled = false
      }
      request_header_modifier {
        set = { "version": "1", "type" : "json"}
        add = { "minor-version": "1"}
        remove = ["arg"]
      }
      response_header_modifier {
        set = { "version": "1", "type" : "json"}
        add = { "minor-version": "1"}
        remove = ["removearg"]
      }
    }
  }
}
