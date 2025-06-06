resource "google_clouddeploy_deploy_policy" "f-deploy-policy" {
  name     = "cd-policy-${local.name_suffix}"
  location = "us-central1"
  annotations = {
    my_first_annotation = "example-annotation-1"
    my_second_annotation = "example-annotation-2"
  }
  labels = {
    my_first_label = "example-label-1"
    my_second_label = "example-label-2"
  }
  description = "policy resource"
  selectors {
    delivery_pipeline {
      id = "cd-pipeline-${local.name_suffix}"
      labels = {
      	foo = "bar"
      }
    }
   }
  selectors {
    target {
      id = "dev"
      labels = {
      	foo = "bar"
      }
    }
  }
  suspended = true
  rules {
    rollout_restriction {
      id = "rule"
      time_windows {
        time_zone = "America/Los_Angeles"
        weekly_windows {
            start_time {
                hours = "12"
                minutes = "00"
                seconds = "00"
                nanos = "00"
            }
            end_time {
                hours = "13"
                minutes = "00"
                seconds = "00"
                nanos = "00"
            }
        }
      }
    }
  }
  rules {
    rollout_restriction {
        id = "rule2"
        invokers = ["USER"] 
        actions = ["CREATE"]
        time_windows {
        time_zone = "America/Los_Angeles"
        weekly_windows {
            start_time {
                hours = "13"
                minutes = "00"
                seconds = "00"
                nanos = "00"
            }
            end_time {
                hours = "14"
                minutes = "00"
                seconds = "00"
                nanos = "00"
            }
            days_of_week = ["MONDAY"]
          }

        one_time_windows {
        start_time {
            hours = "15"
            minutes = "00"
            seconds = "00"
            nanos = "00"
        }
        end_time {
            hours = "16"
            minutes = "00"
            seconds = "00"
            nanos = "00"
        }
        start_date {
            year = "2019"
            month = "01"
            day = "01"
        }
        end_date {
            year = "2019"
            month = "12"
            day = "31"
        }
      }
     }
    }
  }
}
