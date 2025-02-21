resource "google_storage_bucket" "bucket" {
  name                        = "bucket-name-${local.name_suffix}"
  location                    = "US"
}

resource "time_sleep" "destroy_wait_5000_seconds" {
  depends_on = [google_storage_bucket.bucket]
  destroy_duration = "5000s"
}

resource "google_storage_anywhere_cache" "cache" {
  bucket = google_storage_bucket.bucket.name
  zone = "us-central1-f"
  ttl = "3601s"
  depends_on = [time_sleep.destroy_wait_5000_seconds]
}
