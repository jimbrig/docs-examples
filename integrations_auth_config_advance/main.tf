resource "google_integrations_client" "client" {
  location = "asia-east2"
}

resource "google_integrations_auth_config" "advance_example" {
    location = "asia-east2"
    display_name = "test-authconfig-${local.name_suffix}"
    description = "Test auth config created via terraform"
    visibility = "CLIENT_VISIBLE"
    expiry_notification_duration = ["3.500s"]
    override_valid_time = "2014-10-02T15:01:23Z"
    decrypted_credential {
        credential_type = "USERNAME_AND_PASSWORD"
        username_and_password {
            username = "test-username"
            password = "test-password"
        }
    }
    depends_on = [google_integrations_client.client]
}
