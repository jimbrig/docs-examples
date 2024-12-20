resource "google_oracle_database_cloud_exadata_infrastructure" "my-cloud-exadata"{
  cloud_exadata_infrastructure_id = "my-instance-${local.name_suffix}"
  display_name = "my-instance-${local.name_suffix} displayname"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  gcp_oracle_zone = "us-east4-b-r1"
  properties {
    shape = "Exadata.X9M"
    compute_count= "2"
    storage_count= "3"
    customer_contacts {
      email = "xyz@example.com"
    }
    maintenance_window {
      custom_action_timeout_mins       = "20"
      days_of_week                     = ["SUNDAY"]
      hours_of_day                     = [4]
      is_custom_action_timeout_enabled = "0"
      lead_time_week                   = "1"
      months                           = ["JANUARY","APRIL","MAY","OCTOBER"]
      patching_mode                    = "ROLLING"
      preference                       = "CUSTOM_PREFERENCE"
      weeks_of_month                   = [4]
    }
    total_storage_size_gb = "196608"
  }
  labels = {
    "label-one" = "value-one"
  }

  deletion_protection = "true-${local.name_suffix}"
}
