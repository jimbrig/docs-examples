resource "google_dialogflow_cx_agent" "agent" {
  display_name = "dialogflowcx-agent-${local.name_suffix}"
  location = "us-central1"
  default_language_code = "en"
  supported_language_codes = ["it","de","es"]
  time_zone = "America/New_York"
  description = "Example description."
  avatar_uri = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_stackdriver_logging = true
  enable_spell_correction    = true
  speech_to_text_settings {
    enable_speech_adaptation = true
  }
}


resource "google_dialogflow_cx_webhook" "flexible_webhook" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "MyFlow"
  service_directory {
    service = "projects/example-proj/locations/us-central1/namespaces/example-namespace/services/example-service"
    generic_web_service {
      uri = "https://example.com"
      request_headers = { "example-key": "example-value" }
      webhook_type = "FLEXIBLE"
      oauth_config {
        client_id = "example-client-id"
        client_secret = "projects/example-proj/secrets/example-secret/versions/example-version"
        token_endpoint = "https://example.com"
      }
      service_agent_auth = "NONE"
      http_method = "POST"
      request_body = "{\"example-key\": \"example-value\"}"
      parameter_mapping = { "example-parameter": "examplePath" }
    }
  }
}
