resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "example_dataset-${local.name_suffix}"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "aws-us-east-1"

  external_dataset_reference {
    external_source = "aws-glue://arn:aws:glue:us-east-1:772042918353:database/db_other_formats_external"
    connection      = "projects/bigquerytestdefault/locations/aws-us-east-1/connections/external_test-connection"
  }
}
