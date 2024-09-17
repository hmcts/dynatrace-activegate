

module "vm-bootstrap" {
  for_each = var.vm_scale_sets
  source   = "git::https://github.com/hmcts/terraform-module-vm-bootstrap.git?ref=master"

  virtual_machine_type             = "vmss"
  virtual_machine_scale_set_id     = azurerm_linux_virtual_machine_scale_set.main[each.key].id
  install_splunk_uf                = var.install_splunk_uf
  splunk_username                  = var.splunk_username_secret
  splunk_password                  = var.splunk_password_secret
  splunk_pass4symmkey              = var.splunk_pass4symmkey_secret
  splunk_group                     = "hmcts_forwarders"
  os_type                          = local.os_type
  env                              = var.env
  install_dynatrace_oneagent       = false
  install_azure_monitor            = false
  run_command                      = var.run_command
  rc_script_file                   = var.rc_script_file
  run_command_sa_key               = data.azurerm_storage_account.xdr_storage.primary_access_key
  run_xdr_collector                = var.run_xdr_collector
  run_xdr_agent                    = var.run_xdr_agent
  common_tags                      = module.ctags.common_tags
  xdr_tags                         = "Dynatrace,${local.local_env}"
  install_nessus_agent             = var.install_nessus_agent
  run_command_type_handler_version = var.run_command_type_handler_version

  providers = {
    azurerm.cnp = azurerm.cnp
    azurerm.soc = azurerm.soc
  }
}

module "ctags" {
  source       = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment  = var.env
  product      = var.product
  builtFrom    = var.builtFrom
  expiresAfter = var.expiresAfter
}

data "azurerm_storage_account" "xdr_storage" {
  provider            = azurerm.DTS-CFTPTL-INTSVC
  name                = "cftptlintsvc"
  resource_group_name = "core-infra-intsvc-rg"
}

locals {
  prefix      = var.config_file_name == "cloudconfig-private" ? "activegate-private-${var.env}" : "activegate-${var.env}"
  environment = var.env == "prod" ? "ptl" : "${var.env}"
  adminuser   = "azureuser"
}

data "azurerm_key_vault" "subscription_vault" {
  provider            = azurerm.ptl
  name                = var.vault_name
  resource_group_name = var.vault_rg
}

data "azurerm_key_vault_secret" "dynatrace_paas_token" {
  provider     = azurerm.ptl
  name         = "dynatrace-${local.environment}-paas-token"
  key_vault_id = data.azurerm_key_vault.subscription_vault.id
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  provider     = azurerm.ptl
  name         = "aks-ssh-pub-key"
  key_vault_id = data.azurerm_key_vault.subscription_vault.id
}

data "azurerm_key_vault_secret" "public_storage_key" {
  provider     = azurerm.ptl
  name         = "storage-account-key"
  key_vault_id = data.azurerm_key_vault.subscription_vault.id
}

data "azurerm_storage_account" "dynatrace_plugin_storage" {
  provider            = azurerm.ptl
  name                = var.storage_account
  resource_group_name = var.storage_account_rg
}

data "template_file" "cloudconfig" {
  for_each = var.vm_scale_sets
  template = each.key == "dynatrace-activegate" ? file("${path.module}/cloudconfig.tpl") : file("${path.module}/cloudconfig-private.tpl")

  vars = {
    paas_token               = data.azurerm_key_vault_secret.dynatrace_paas_token.value
    dynatrace_instance_name  = var.dynatrace_instance_name
    network_zone             = var.network_zone
    group                    = "cft-${var.env}"
    plugin_storage_account   = data.azurerm_storage_account.dynatrace_plugin_storage.name
    plugin_storage_container = var.storage_container
    plugin_storage_key       = data.azurerm_key_vault_secret.public_storage_key.value
    dynatrace_plugins        = join(" ", var.dynatrace_plugins)
  }
}

data "template_cloudinit_config" "config" {
  for_each      = var.vm_scale_sets
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig[each.key].rendered
  }
}

data "azurerm_key_vault" "soc_vault" {
  provider            = azurerm.soc
  name                = var.soc_vault_name
  resource_group_name = var.soc_vault_rg
}

data "azurerm_key_vault_secret" "splunk_username" {
  provider     = azurerm.soc
  name         = var.splunk_username_secret
  key_vault_id = data.azurerm_key_vault.soc_vault.id
}

data "azurerm_key_vault_secret" "splunk_password" {
  provider     = azurerm.soc
  name         = var.splunk_password_secret
  key_vault_id = data.azurerm_key_vault.soc_vault.id
}

data "azurerm_key_vault_secret" "splunk_pass4symmkey" {
  provider     = azurerm.soc
  name         = var.splunk_pass4symmkey_secret
  key_vault_id = data.azurerm_key_vault.soc_vault.id
}

resource "azurerm_linux_virtual_machine_scale_set" "main" {
  for_each            = var.vm_scale_sets
  name                = "${each.key}-${var.env}-vmss"
  resource_group_name = module.networking.resource_group_name
  location            = var.location
  sku                 = var.sku
  instances           = each.value.instances

  admin_username = local.adminuser
  admin_ssh_key {
    username   = local.adminuser
    public_key = data.azurerm_key_vault_secret.ssh_public_key.value
  }

  # Please note that custom_data updates will cause VMs to restart
  custom_data = data.template_cloudinit_config.config[each.key].rendered

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.image_sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.storage_account_type
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.name}-${var.env}-ni"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = module.networking.subnet_ids["${var.name}-subnet0"]
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = module.ctags.common_tags
}

resource "azurerm_virtual_machine_scale_set_extension" "azuread_login" {
  for_each                     = var.vm_scale_sets
  name                         = "AADSSHLoginForLinux"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.main[each.key].id
  publisher                    = "Microsoft.Azure.ActiveDirectory"
  type                         = "AADSSHLoginForLinux"
  type_handler_version         = "1.0"
  auto_upgrade_minor_version   = true
}

module "splunk-uf" {
  for_each = { for k, v in var.vm_scale_sets : k => v if v.add_splunk == true }

  source = "git::https://github.com/hmcts/terraform-module-splunk-universal-forwarder.git?ref=master"

  auto_upgrade_minor_version   = true
  virtual_machine_type         = "vmss"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.main[each.key].id
  splunk_username              = data.azurerm_key_vault_secret.splunk_username.value
  splunk_password              = data.azurerm_key_vault_secret.splunk_password.value
  splunk_pass4symmkey          = data.azurerm_key_vault_secret.splunk_pass4symmkey.value
}
