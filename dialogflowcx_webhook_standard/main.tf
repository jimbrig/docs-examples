resource "google_dialogflow_cx_agent" "agent" {
  display_name = "dialogflowcx-agent-${local.name_suffix}"
  location = "global"
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


resource "google_dialogflow_cx_webhook" "standard_webhook" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "MyFlow"
  generic_web_service {
    allowed_ca_certs = ["BQA="]
		uri = "https://example.com"
    request_headers = { "example-key": "example-value" }
    webhook_type = "STANDARD"
    oauth_config {
      client_id = "example-client-id"
      secret_version_for_client_secret = "projects/example-proj/secrets/example-secret/versions/example-version"
      token_endpoint = "https://example.com"
      scopes = ["example-scope"]
    }
    service_agent_auth = "NONE"
    secret_version_for_username_password = "projects/example-proj/secrets/example-secret/versions/example-version"
    secret_versions_for_request_headers {
      key = "example-key-1"
      secret_version = "projects/example-proj/secrets/example-secret/versions/example-version"
    }
    secret_versions_for_request_headers {
      key = "example-key-2"
      secret_version = "projects/example-proj/secrets/example-secret/versions/example-version-2"
    }
	}
}
