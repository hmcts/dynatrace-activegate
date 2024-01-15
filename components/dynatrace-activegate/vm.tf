
module "ctags" {
  source       = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment  = var.env
  product      = var.product
  builtFrom    = var.builtFrom
  expiresAfter = var.expiresAfter
}


locals {
  prefix      = var.config_file_name == "cloudconfig-private" ? "activegate-private-${var.env}" : "activegate-${var.env}"
  environment = var.env == "ptl" ? "prod" : "${var.env}"
  adminuser   = "azureuser"
}

data "azurerm_key_vault" "subscription_vault" {
  provider            = azurerm.ptl
  name                = var.vault_name
  resource_group_name = var.vault_rg
}

data "azurerm_key_vault_secret" "dynatrace_paas_token" {
  provider     = azurerm.ptl
  name         = "dynatrace-${var.env}-paas-token"
  key_vault_id = data.azurerm_key_vault.subscription_vault.id
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  provider     = azurerm.ptl
  name         = "aks-ssh-pub-key"
  key_vault_id = data.azurerm_key_vault.subscription_vault.id
}

data "azurerm_storage_account" "dynatrace_plugin_storage" {
  provider            = azurerm.ptl
  name                = var.storage_account
  resource_group_name = var.storage_account_rg
}


data "template_file" "cloudconfig" {
  template = file("${path.module}/cloudconfig.tpl")

  vars = {
    paas_token               = data.azurerm_key_vault_secret.dynatrace_paas_token.value
    dynatrace_instance_name  = var.dynatrace_instance_name
    network_zone             = var.network_zone
    plugin_storage_account   = data.azurerm_storage_account.dynatrace_plugin_storage.name
    plugin_storage_container = var.storage_container
    plugin_storage_key       = data.azurerm_storage_account.dynatrace_plugin_storage.primary_access_key
    dynatrace_plugins        = join(" ", var.dynatrace_plugins)
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }
}

data "template_file" "private_cloudconfig" {
  template = file("${path.module}/cloudconfig-private.tpl")

  vars = {
    paas_token               = data.azurerm_key_vault_secret.dynatrace_paas_token.value
    dynatrace_instance_name  = var.dynatrace_instance_name
    network_zone             = var.network_zone
    plugin_storage_account   = data.azurerm_storage_account.dynatrace_plugin_storage.name
    plugin_storage_container = var.storage_container
    plugin_storage_key       = data.azurerm_storage_account.dynatrace_plugin_storage.primary_access_key
    dynatrace_plugins        = join(" ", var.dynatrace_plugins)
  }
}

data "template_cloudinit_config" "private_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.private_cloudconfig.rendered
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
  name                = "dynatrace-activegate-${var.env}-vmss"
  resource_group_name = module.vnet.resourcegroup_name
  location            = var.location
  sku                 = var.sku
  instances           = var.instance_count

  admin_username = local.adminuser
  admin_ssh_key {
    username   = local.adminuser
    public_key = data.azurerm_key_vault_secret.ssh_public_key.value
  }

  # Please note that custom_data updates will cause VMs to restart
  custom_data = data.template_cloudinit_config.config.rendered

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
      subnet_id = module.vnet.subnet_ids[0]
    }

  }

  tags = module.ctags.common_tags
}

# resource "azurerm_linux_virtual_machine_scale_set" "private" {
#   name                = "dynatrace-activegate-private-${var.env}-vmss"
#   resource_group_name = module.vnet.resourcegroup_name
#   location            = var.location
#   sku                 = var.sku
#   instances           = var.instance_count

#   admin_username = local.adminuser
#   admin_ssh_key {
#     username   = local.adminuser
#     public_key = data.azurerm_key_vault_secret.ssh_public_key.value
#   }

#   # Please note that custom_data updates will cause VMs to restart
#   custom_data = data.template_cloudinit_config.private_config.rendered

#   source_image_reference {
#     publisher = var.publisher
#     offer     = var.offer
#     sku       = var.image_sku
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = var.storage_account_type
#     caching              = "ReadWrite"
#   }

#   network_interface {
#     name    = "${var.name}-${var.env}-private-ni"
#     primary = true

#     ip_configuration {
#       name      = "internal"
#       primary   = true
#       subnet_id = module.vnet.subnet_ids[0]
#     }
#   }

#    tags = var.common_tags
# }

# data "azurerm_log_analytics_workspace" "law" {
#   provider            = azurerm.law
#   name                = "hmcts-${local.environment}"
#   resource_group_name = "oms-automation"
# }

# resource "azurerm_virtual_machine_scale_set_extension" "OmsAgentForLinux" {

#   count = var.enable_log_analytics ? 1 : 0

#   name                         = "OmsAgentForLinux"
#   virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.main.id
#   publisher                    = "Microsoft.EnterpriseCloud.Monitoring"
#   type                         = "OmsAgentForLinux"
#   type_handler_version         = "1.13"
#   auto_upgrade_minor_version   = true

#   settings = <<SETTINGS
#     {
#         "workspaceId": "${data.azurerm_log_analytics_workspace.law.workspace_id}"
#     }
#     SETTINGS

#   protected_settings = <<PROTECTED_SETTINGS
#     {
#         "workspaceKey": "${data.azurerm_log_analytics_workspace.law.primary_shared_key}"
#     }
#     PROTECTED_SETTINGS
# }


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
