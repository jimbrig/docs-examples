resource "google_blockchain_node_engine_blockchain_nodes" "default_node_geth" {
  location = "us-central1"
  blockchain_type = "ETHEREUM"
  blockchain_node_id = "blockchain_geth_node-${local.name_suffix}"
  ethereum_details {
    api_enable_admin = true
    api_enable_debug = true
    validator_config {
      mev_relay_urls = ["https://mev1.example.org/","https://mev2.example.org/"]
    }
    node_type = "FULL"
    consensus_client = "LIGHTHOUSE"
    execution_client = "GETH"
    network = "MAINNET"
    geth_details {
      garbage_collection_mode = "FULL"
    }
  }
  
  labels = {
    environment = "dev"
  }
}