data "google_project" "project" {
}

resource "google_healthcare_pipeline_job" "recon" {
  name  = "example_recon_pipeline_job-${local.name_suffix}"
  location = "us-central1"
  dataset = google_healthcare_dataset.dataset.id
  disable_lineage = true
  reconciliation_pipeline_job {
    merge_config {
      description = "sample description for reconciliation rules"
      whistle_config_source {
        uri = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.merge_file.name}"
        import_uri_prefix = "gs://${google_storage_bucket.bucket.name}"
      }
    }
    matching_uri_prefix = "gs://${google_storage_bucket.bucket.name}"
    fhir_store_destination = "${google_healthcare_dataset.dataset.id}/fhirStores/${google_healthcare_fhir_store.dest_fhirstore.name}"
  }
}

resource "google_healthcare_pipeline_job" "example-mapping-pipeline" {
  depends_on = [google_healthcare_pipeline_job.recon]
  name  = "example_mapping_pipeline_job-${local.name_suffix}"
  location = "us-central1"
  dataset = google_healthcare_dataset.dataset.id
  disable_lineage = true
  labels = {
    example_label_key = "example_label_value"
  }
  mapping_pipeline_job {
    mapping_config {
      whistle_config_source {
        uri = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.mapping_file.name}"
        import_uri_prefix = "gs://${google_storage_bucket.bucket.name}"
      }
      description = "example description for mapping configuration"
    }
    fhir_streaming_source {
      fhir_store = "${google_healthcare_dataset.dataset.id}/fhirStores/${google_healthcare_fhir_store.source_fhirstore.name}"
      description = "example description for streaming fhirstore"
    }
    reconciliation_destination = true
  }
}

resource "google_healthcare_dataset" "dataset" {
  name     = "example_dataset-${local.name_suffix}"
  location = "us-central1"
}

resource "google_healthcare_fhir_store" "source_fhirstore" {
  name    = "source_fhir_store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id
  version = "R4"
  enable_update_create          = true
  disable_referential_integrity = true
}

resource "google_healthcare_fhir_store" "dest_fhirstore" {
  name    = "dest_fhir_store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id
  version = "R4"
  enable_update_create          = true
  disable_referential_integrity = true
}

resource "google_storage_bucket" "bucket" {
    name          = "example_bucket_name-${local.name_suffix}"
    location      = "us-central1"
    uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "mapping_file" {
  name    = "mapping.wstl"
  content = " "
  bucket  = google_storage_bucket.bucket.name
}

resource "google_storage_bucket_object" "merge_file" {
  name    = "merge.wstl"
  content = " "
  bucket  = google_storage_bucket.bucket.name
}

resource "google_storage_bucket_iam_member" "hsa" {
    bucket = google_storage_bucket.bucket.name
    role   = "roles/storage.objectUser"
    member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-healthcare.iam.gserviceaccount.com"
}
