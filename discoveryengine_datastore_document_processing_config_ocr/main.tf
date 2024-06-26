resource "google_discovery_engine_data_store" "document_processing_config_ocr" {
  location                    = "global"
  data_store_id               = "data-store-id-${local.name_suffix}"
  display_name                = "tf-test-structured-datastore"
  industry_vertical           = "GENERIC"
  content_config              = "NO_CONTENT"
  solution_types              = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search = false
  document_processing_config {
    default_parsing_config {
      ocr_parsing_config {
        use_native_text = true
      }
    }
  }      
}
