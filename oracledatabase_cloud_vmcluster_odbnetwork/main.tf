resource "google_oracle_database_cloud_vm_cluster" "my_vmcluster"{
  cloud_vm_cluster_id = "my-instance-${local.name_suffix}"
  display_name = "my-instance-${local.name_suffix} displayname"
  location = "europe-west2"
  project = "my-project-${local.name_suffix}"
  exadata_infrastructure = google_oracle_database_cloud_exadata_infrastructure.cloudExadataInfrastructures.id
  odb_network = "projects/my-project/locations/europe-west2/odbNetworks/my-odbnetwork-${local.name_suffix}"
  odb_subnet = "projects/my-project/locations/europe-west2/odbNetworks/my-odbnetwork/odbSubnets/my-odbsubnet-${local.name_suffix}"
  backup_odb_subnet = "projects/my-project/locations/europe-west2/odbNetworks/my-odbnetwork/odbSubnets/my-backup-odbsubnet-${local.name_suffix}"
  properties {
    license_type = "LICENSE_INCLUDED"
    ssh_public_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCz1X2744t+6vRLmE5u6nHi6/QWh8bQDgHmd+OIxRQIGA/IWUtCs2FnaCNZcqvZkaeyjk5v0lTA/n+9jvO42Ipib53athrfVG8gRt8fzPL66C6ZqHq+6zZophhrCdfJh/0G4x9xJh5gdMprlaCR1P8yAaVvhBQSKGc4SiIkyMNBcHJ5YTtMQMTfxaB4G1sHZ6SDAY9a6Cq/zNjDwfPapWLsiP4mRhE5SSjJX6l6EYbkm0JeLQg+AbJiNEPvrvDp1wtTxzlPJtIivthmLMThFxK7+DkrYFuLvN5AHUdo9KTDLvHtDCvV70r8v0gafsrKkM/OE9Jtzoo0e1N/5K/ZdyFRbAkFT4QSF3nwpbmBWLf2Evg//YyEuxnz4CwPqFST2mucnrCCGCVWp1vnHZ0y30nM35njLOmWdRDFy5l27pKUTwLp02y3UYiiZyP7d3/u5pKiN4vC27VuvzprSdJxWoAvluOiDeRh+/oeQDowxoT/Oop8DzB9uJmjktXw8jyMW2+Rpg+ENQqeNgF1OGlEzypaWiRskEFlkpLb4v/s3ZDYkL1oW0Nv/J8LTjTOTEaYt2Udjoe9x2xWiGnQixhdChWuG+MaoWffzUgx1tsVj/DBXijR5DjkPkrA1GA98zd3q8GKEaAdcDenJjHhNYSd4+rE9pIsnYn7fo5X/tFfcQH1XQ== nobody@google.com"]
    cpu_core_count = "4"
    gi_version = "19.0.0.0"
    hostname_prefix = "hostname1"
  }

  deletion_protection = "true-${local.name_suffix}"
}

resource "google_oracle_database_cloud_exadata_infrastructure" "cloudExadataInfrastructures"{
  cloud_exadata_infrastructure_id = "my-exadata-${local.name_suffix}"
  display_name = "my-exadata-${local.name_suffix} displayname"
  location = "europe-west2"
  project = "my-project-${local.name_suffix}"
  properties {
    shape = "Exadata.X9M"
    compute_count= "2"
    storage_count= "3"
  }

  deletion_protection = "true-${local.name_suffix}"
}
