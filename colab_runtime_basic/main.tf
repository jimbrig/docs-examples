resource "google_colab_runtime_template" "my_template" {
  name = "colab-runtime-${local.name_suffix}"
  display_name = "Runtime template basic"
  location = "us-central1"

  machine_spec {
    machine_type     = "e2-standard-4"
  }

  network_spec {
    enable_internet_access = true
  }
}

resource "google_colab_runtime" "runtime" {
  name = "colab-runtime-${local.name_suffix}"
  location = "us-central1" 
  
  notebook_runtime_template_ref {
    notebook_runtime_template = google_colab_runtime_template.my_template.id
  }
  
  display_name = "Runtime basic"
  runtime_user = "gterraformtestuser@gmail.com"

  depends_on = [
    google_colab_runtime_template.my_template,
  ]
}