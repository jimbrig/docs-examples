resource "google_privateca_ca_pool" "default" {
  name      = "my-basic-ca-pool-${local.name_suffix}"
  location  = "us-central1"
  tier     = "DEVOPS"
  publishing_options {
    publish_ca_cert = false
    publish_crl = false
  }
  issuance_policy {
    maximum_lifetime = "1209600s"
    baseline_values {
      ca_options {
        is_ca = false
      }
      key_usage {
        base_key_usage {}
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
}

resource "google_privateca_certificate_authority" "default" {
  pool = google_privateca_ca_pool.default.name
  certificate_authority_id = "my-basic-certificate-authority-${local.name_suffix}"
  location = "us-central1"
  lifetime = "86400s"
  type = "SELF_SIGNED"
  deletion_protection = false
  skip_grace_period = true
  ignore_active_certificates_on_deletion = true
  config {
    subject_config {
      subject {
        organization = "Test LLC"
        common_name = "my-ca"
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
          server_auth = false
        }
      }
    }
  }
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }
}

data "google_project" "project" {
}

resource "google_privateca_ca_pool_iam_member" "tls_inspection_permission" {
  ca_pool = google_privateca_ca_pool.default.id
  role = "roles/privateca.certificateManager"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-networksecurity.iam.gserviceaccount.com"
}

resource "google_network_security_tls_inspection_policy" "default" {
  name     = "my-tls-inspection-policy-${local.name_suffix}"
  location = "us-central1"
  ca_pool  = google_privateca_ca_pool.default.id
  depends_on = [google_privateca_ca_pool.default, google_privateca_certificate_authority.default, google_privateca_ca_pool_iam_member.tls_inspection_permission]
}

resource "google_network_security_gateway_security_policy" "default" {
  name        = "my-gateway-security-policy-${local.name_suffix}"
  location    = "us-central1"
  description = "my description"
  tls_inspection_policy = google_network_security_tls_inspection_policy.default.id
  depends_on = [google_network_security_tls_inspection_policy.default]
}
