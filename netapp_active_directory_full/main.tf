resource "google_netapp_active_directory" "test_active_directory_full" {
    name = "test-active-directory-full-${local.name_suffix}"
    location = "us-central1"
    domain = "ad.internal"
    dns = "172.30.64.3"
    net_bios_prefix = "smbserver"
    username = "user"
    password = "pass"
    aes_encryption         = false
    backup_operators       = ["test1", "test2"]
    administrators         = ["test1", "test2"]
    description            = "ActiveDirectory is the public representation of the active directory config."
    encrypt_dc_connections = false
    kdc_hostname           = "hostname"
    kdc_ip                 = "10.10.0.11"
    labels                 = { 
        "foo": "bar"
    }
    ldap_signing           = false
    nfs_users_with_ldap    = false
    organizational_unit    = "CN=Computers"
    security_operators     = ["test1", "test2"]
    site                   = "test-site"
  }
