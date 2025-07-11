resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      base_image_uri = "us-central1-docker.pkg.dev/serverless-runtimes/google-22-full/runtimes/nodejs22"
    }
  }
  build_config {
    source_location = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    function_target = "helloHttp"
    image_uri = "us-docker.pkg.dev/cloudrun/container/hello"
    base_image = "us-central1-docker.pkg.dev/serverless-runtimes/google-22-full/runtimes/nodejs22"
    enable_automatic_updates = true
    environment_variables = {
      FOO_KEY = "FOO_VALUE"
      BAR_KEY = "BAR_VALUE"
    }
    service_account = google_service_account.cloudbuild_service_account.id
  }
  depends_on = [
    google_project_iam_member.act_as,
    google_project_iam_member.logs_writer
  ]
}

data "google_project" "project" {
}

resource "google_storage_bucket" "bucket" {
  name     = "${data.google_project.project.project_id}-gcf-source-${local.name_suffix}"  # Every bucket name must be globally unique
  location = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.bucket.name
  source = "function_source.zip-${local.name_suffix}"  # Add path to the zipped function source code
}

resource "google_service_account" "cloudbuild_service_account" {
  account_id = "build-sa-${local.name_suffix}"
}

resource "google_project_iam_member" "act_as" {
  project = data.google_project.project.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "logs_writer" {
  project = data.google_project.project.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}
