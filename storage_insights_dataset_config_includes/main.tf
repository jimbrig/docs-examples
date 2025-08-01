resource "google_storage_insights_dataset_config" "config_includes" {
    location = "us-central1"
    dataset_config_id = "my_config_includes-${local.name_suffix}"
    retention_period_days = 1
    source_projects {
        project_numbers = ["123", "456", "789"]
    }
    identity {
        type = "IDENTITY_TYPE_PER_CONFIG"
    }
    description = "Sample Description"
    link_dataset = false
    include_newly_created_buckets = true
    include_cloud_storage_locations {
        locations = ["us-east1"]
    }
    include_cloud_storage_buckets {
        cloud_storage_buckets {
            bucket_name = "sample-bucket"
        }
        cloud_storage_buckets {
            bucket_name = "sample-regex"
        }
    }
}
