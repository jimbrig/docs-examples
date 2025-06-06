resource "google_dataplex_glossary" "term_test_id" {
  glossary_id = "tf-test-glossary%{random_suffix}"
  location = "us-central1"
}

resource "google_dataplex_glossary_term" "term_test_id" {
  parent = "projects/${google_dataplex_glossary.term_test_id.project}/locations/us-central1/glossaries/${google_dataplex_glossary.term_test_id.glossary_id}"
  glossary_id = google_dataplex_glossary.term_test_id.glossary_id 
  location = "us-central1"
  term_id = "tf-test-term-basic%{random_suffix}"
}
