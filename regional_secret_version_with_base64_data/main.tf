resource "google_secret_manager_regional_secret" "secret-basic" {
  secret_id = "secret-version-${local.name_suffix}"
  location = "us-central1"
}

resource "google_secret_manager_regional_secret_version" "regional_secret_version_base64" {
  secret = google_secret_manager_regional_secret.secret-basic.id
  secret_data = filebase64("secret-data.pfx-${local.name_suffix}")
  is_secret_data_base64 = true
}
