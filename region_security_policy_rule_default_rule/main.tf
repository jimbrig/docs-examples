resource "google_compute_region_security_policy" "default" {
  region      = "us-west2"
  name        = "policywithdefaultrule-${local.name_suffix}"
  description = "basic region security policy"
  type        = "CLOUD_ARMOR"
}

resource "google_compute_region_security_policy_rule" "default_rule" {
  region          = "us-west2"
  security_policy = google_compute_region_security_policy.default.name
  description     = "new rule"
  action          = "deny"
  priority        = "2147483647"
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["*"]
    }
  }
}

resource "google_compute_region_security_policy_rule" "policy_rule" {
  region          = "us-west2"
  security_policy = google_compute_region_security_policy.default.name
  description     = "new rule"
  priority        = 100
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["10.10.0.0/16"]
    }
  }
  action          = "allow"
  preview         = true
}
