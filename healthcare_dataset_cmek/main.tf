data "google_project" "project" {}

resource "google_healthcare_dataset" "default" {
  name      = "example-dataset-${local.name_suffix}"
  location  = "us-central1"
  time_zone = "UTC"

  encryption_spec {
    kms_key_name = google_kms_crypto_key.crypto_key.id
  }

  depends_on = [
    google_kms_crypto_key_iam_binding.healthcare_cmek_keyuser
  ]
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "example-key-${local.name_suffix}"
  key_ring = google_kms_key_ring.key_ring.id
  purpose  = "ENCRYPT_DECRYPT"
}

resource "google_kms_key_ring" "key_ring" {
  name     = "example-keyring-${local.name_suffix}"
  location = "us-central1"
}

resource "google_kms_crypto_key_iam_binding" "healthcare_cmek_keyuser" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-healthcare.iam.gserviceaccount.com",
  ]
}

