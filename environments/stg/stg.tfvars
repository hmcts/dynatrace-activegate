subscription = "ptl"

# BFA variables
mgmt_vnet_name = "core-cftptl-intsvc-vnet"
mgmt_rg_name   = "aks-infra-cftptl-intsvc-rg"
kv_rg_name     = "core-infra-intsvc-rg"

data_subscription = "8999dec3-0104-4a27-94ee-6588559729d1"
oms_env           = "prod"


dynatrace_instance_name = "yrk32651"
env                     = "nonprod"
network_zone            = "azure.cft"
config_file_name        = "cloudconfig-private"
install_splunk_uf       = true
enable_log_analytics    = true

vm_scale_sets = {
    dynatrace-activegate = {
        computer_name_prefix    = "dyn-ag"
        instance_count          = 2
    }
    dynatrace-activegate-private = {
        computer_name_prefix    = "dyn-ag-private"
        instance_count          = 2
    }
}