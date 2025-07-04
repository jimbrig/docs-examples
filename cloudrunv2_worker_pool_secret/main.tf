resource "google_cloud_run_v2_worker_pool" "default" {
  name     = "cloudrun-worker-pool-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  launch_stage = "BETA"

  template {
    volumes {
      name = "a-volume"
      secret {
        secret = google_secret_manager_secret.secret.secret_id
        default_mode = 292 # 0444
        items {
          version = "1"
          path = "my-secret"
          mode = 0444
        }
      }
    }
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/worker-pool"
      volume_mounts {
        name = "a-volume"
        mount_path = "/secrets"
      }
    }
  }
  depends_on = [google_secret_manager_secret_version.secret-version-data]
}

data "google_project" "project" {
}

resource "google_secret_manager_secret" "secret" {
  secret_id = "secret-1-${local.name_suffix}"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  secret = google_secret_manager_secret.secret.name
  secret_data = "secret-data"
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.secret]
}
