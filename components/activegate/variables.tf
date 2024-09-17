// terraform doesn't let you have undeclared vars used from a tfvars file but no variable declaration
// we link this file into each component
// from the component dir: `ln -s ../../environments/variables.tf variables.tf`

variable "subscription" {
  default = []
}

variable "key_vault_subscription" {
  default = []
}

variable "env" {
  default = []
}

variable "project" {
  default = "hmcts"
}

variable "product" {
}

variable "publisher_email" {
  default = "DTSPlatformOperations@justice.gov.uk"
}

variable "builtFrom" {
  default = "hmcts/azure-platform-terraform"
}

variable "shutter_rg" {
  default = "TODO"
}

variable "location" {
  default = "UK South"
}

variable "frontends" {
  default = []
}

variable "shutter_storage" {
  default = "TODO" // Is this even used?
}
variable "default_shutter" {
  default = []
}

variable "cdn_sku" {
  default = "Standard_Verizon"
}

variable "ssl_mode" {
  default = "FrontDoor"
}

variable "cft_apps_cluster_ips" {
  default = []
}
variable "frontend_agw_private_ip_address" {
  default = []
}
variable "sscssya_shutter" {
  default = []
}
variable "sscstya_shutter" {
  default = []
}
variable "sscscor_shutter" {
  default = []
}

variable "hub_app_gw_private_ip_address" {
  default = []
}

variable "backend_agw_private_ip_address" {
  default = []
}

variable "mgmt_vnet_name" {
  default = "TODO"
}
variable "mgmt_rg_name" {
  default = "TODO"
}
variable "kv_rg_name" {
  default = "TODO"
}

variable "data_subscription" {}

variable "privatedns_subscription" {
  default = "TODO"
}
variable "oms_env" {}

variable "certificate_name_check" {
  default = true
}

variable "common_tags" {
  default = []
}

variable "add_access_policy" {
  default = true
}

variable "department" {
  default = "cft"
}

variable "apim_sku_name" {
  default = "Developer"
}

variable "hub" {
  default = "sbox"
}

variable "waf_mode" {
  default = "Detection"
}

variable "route_next_hop_type" {
  default = "VirtualAppliance"
}

variable "apim_appgw_backend_pool_ips" {
  default = []
}

variable "apim_appgw_backend_pool_fqdns" {
  default = []
}

variable "apim_appgw_exclusions" {
  default = []
}

variable "expiresAfter" {
  description = "Date when Sandbox resources can be deleted. Format: YYYY-MM-DD"
  default     = "3000-01-01"
}

variable "backend_agw_min_capacity" {
  description = "Backend Appgw Min capacity"
  default     = 2
}

variable "frontend_agw_min_capacity" {
  description = "Frontend Appgw Min capacity"
  default     = 2
}

variable "backend_agw_max_capacity" {
  description = "Backend Appgw Min capacity"
  default     = 10
}

variable "frontend_agw_max_capacity" {
  description = "Frontend Appgw Max capacity"
  default     = 10
}

variable "apim_appgw_min_capacity" {
  default = 1
}

variable "autoShutdown" {
  default = false
}
variable "apim_appgw_max_capacity" {
  default = 2
}

variable "name" {
  type    = string
  default = "dynatrace-activegate"
}

variable "resource_group_name" {
  default = "aks-infra-cftptl-intsvc-rg"
}

variable "vnet_name" {
  default = "core-cftptl-intsvc-vnet"
}

variable "vault_name" {
  default = "cftptl-intsvc"
}

variable "vault_rg" {
  default = "core-infra-intsvc-rg"
}

variable "dynatrace_instance_name" {
  default = "ebe20728"
}

variable "network_zone" {
  default = ""
}


variable "sku" {
  default = "Standard_D2s_v3"
}

variable "dynatrace_plugins" {
  type    = list(string)
  default = ["custom.remote.python.snmp_palo_alto.zip"]
}

variable "storage_account_rg" {
  default = "core-infra-intsvc-rg"
}

variable "storage_account" {
  default = "cftptlintsvc"
}

variable "storage_container" {
  default = "plugin"
}

variable "config_file_name" {
  default = "cloudconfig"
}

variable "enable_log_analytics" {
  default = false
}

variable "install_splunk_uf" {
  default = false
}

variable "soc_vault_name" {
  default = "soc-prod"
}

variable "soc_vault_rg" {
  default = "soc-core-infra-prod-rg"
}

variable "splunk_username_secret" {
  default = "splunk-gui-admin-username"
}

variable "splunk_password_secret" {
  default = "splunk-gui-admin-password"
}

variable "splunk_pass4symmkey_secret" {
  default = "pass4SymmKey-forwarders-plaintext"
}

variable "address_space" {
}

variable "subnet_count" {
  default = "2"
}

variable "subnet_prefix_length" {
  default = "2"
}

variable "publisher" {
  default = "Canonical"
}

variable "offer" {
  default = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  default = "22_04-lts"
}

variable "storage_account_type" {
  default = "Standard_LRS"
}

variable "vm_scale_sets" {
  description = "The VM Scale sets configuration variable"
  default     = {}
}

variable "address_prefix_subnet0" {

}

variable "address_prefix_subnet1" {

}
variable "next_hop_in_ip_address" {
}

variable "additional_routes" {
  type = map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = {}
}

variable "run_command" {
  type    = bool
  default = false
}

variable "rc_script_file" {
  description = "A path to a local file for the script"
  default     = null
}

variable "run_xdr_collector" {
  type        = bool
  default     = false
  description = "Install XDR collectors hardening using run command script"
}

variable "run_xdr_agent" {
  type        = bool
  default     = false
  description = "Install XDR agents using run command script"
}

variable "cnp_vault_sub" {
  default = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}

variable "vm_count" {
  default = "0"
}

variable "os_type" {
  default = null
}

variable "install_nessus_agent" {
  description = "Install Nessus Agent."
  type        = bool
  default     = false
}

variable "run_command_type_handler_version" {
  description = "Type handler version number"
  type        = string
  default     = "1.2"
}
