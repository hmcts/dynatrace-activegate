subscription = "ptl"

# BFA variables
mgmt_vnet_name = "core-cftptl-intsvc-vnet"
mgmt_rg_name   = "aks-infra-cftptl-intsvc-rg"
kv_rg_name     = "core-infra-intsvc-rg"

data_subscription = "8999dec3-0104-4a27-94ee-6588559729d1"
oms_env           = "prod"

env                  = "prod"
network_zone         = "azure.cft"
config_file_name     = "cloudconfig-private"
install_splunk_uf    = false
enable_log_analytics = true

address_space = "10.10.81.0/24"

address_prefix_subnet0 = "10.10.81.0/26"
address_prefix_subnet1 = "10.10.81.64/26"

next_hop_in_ip_address = "10.11.8.36"

vm_scale_sets = {
  dynatrace-activegate = {
    instances  = 3
    add_splunk = false
  }
  dynatrace-activegate-private = {
    instances  = 2
    add_splunk = false
  }
}

additional_routes = {
  interrim-hosting = {
    address_prefix         = "10.23.15.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.11.8.37"
  }
  cft-aks-sbox = {
    address_prefix         = "10.2.8.0/21"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.200.36"
  }
  cft-aks-ptlsbox = {
    address_prefix         = "10.70.24.0/21"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.200.36"
  }
}

# Install XDR collector using run command
run_command       = true
run_xdr_collector = false
run_xdr_agent     = true
