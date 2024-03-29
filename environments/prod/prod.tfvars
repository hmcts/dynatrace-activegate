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
install_splunk_uf    = true
enable_log_analytics = true

address_space = "10.10.81.0/24"

address_prefix_subnet0 = "10.10.81.0/26"
address_prefix_subnet1 = "10.10.81.64/26"

next_hop_in_ip_address = "10.11.8.36"

vm_scale_sets = {
  dynatrace-activegate = {
    instances  = 3
    add_splunk = true
  }
  dynatrace-activegate-private = {
    instances  = 2
    add_splunk = true
  }
}