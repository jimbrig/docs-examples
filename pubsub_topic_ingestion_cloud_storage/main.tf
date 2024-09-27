resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"

  # Outside of automated terraform-provider-google CI tests, these values must be of actual Cloud Storage resources for the test to pass.
  ingestion_data_source_settings {
    cloud_storage {
        bucket = "test-bucket"
        text_format {
            delimiter = " "
        }
        minimum_object_create_time = "2024-01-01T00:00:00Z"
        match_glob = "foo/**"
    }
    platform_logs_settings {
        severity = "WARNING"
    }
  }
}