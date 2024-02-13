resource "google_clouddeploy_custom_target_type" "custom-target-type" {
    location = "us-central1"
    name = "my-custom-target-type-${local.name_suffix}"
    description = "My custom target type"
    annotations = {
      my_first_annotation = "example-annotation-1"
      my_second_annotation = "example-annotation-2"
    }
    labels = {
      my_first_label = "example-label-1"
      my_second_label = "example-label-2"
    }
    custom_actions {
      render_action = "renderAction"
      deploy_action = "deployAction"
    }
}
