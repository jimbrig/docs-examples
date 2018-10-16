# You may also want to control name generation explicitly:
resource "google_compute_region_ssl_certificate" "default" {
  provider = google-beta
  region   = "us-central1"

  # The name will contain 8 random hex digits,
  # e.g. "my-certificate-48ab27cd2a"
  name        = random_id.certificate.hex
  private_key = file("../static/ssl_cert/test.key")
  certificate = file("../static/ssl_cert/test.crt")

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_id" "certificate" {
  byte_length = 4
  prefix      = "my-certificate-"

  # For security, do not expose raw certificate values in the output
  keepers = {
    private_key = filebase64sha256("../static/ssl_cert/test.key")
    certificate = filebase64sha256("../static/ssl_cert/test.crt")
  }
}
