resource "google_monitoring_group" "parent" {
  display_name = "tf-test MonitoringParentGroup-${local.name_suffix}"
  filter       = "resource.metadata.region=\"europe-west2\""
}

resource "google_monitoring_group" "subgroup" {
  display_name = "tf-test MonitoringSubGroup-${local.name_suffix}"
  filter       = "resource.metadata.region=\"europe-west2\""
  parent_name  =  google_monitoring_group.parent.name
}
