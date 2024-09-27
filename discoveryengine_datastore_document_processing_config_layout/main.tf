resource "google_discovery_engine_data_store" "document_processing_config_layout" {
  location                    = "global"
  data_store_id               = "data-store-id-${local.name_suffix}"
  display_name                = "tf-test-structured-datastore"
  industry_vertical           = "GENERIC"
  content_config              = "CONTENT_REQUIRED"
  solution_types              = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search = true
  document_processing_config {
    default_parsing_config {
      layout_parsing_config {}
    }
    chunking_config {
      layout_based_chunking_config {
        chunk_size                = 500
        include_ancestor_headings = true
      }
    }
  }      
}