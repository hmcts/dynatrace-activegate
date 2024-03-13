data "azurerm_role_definition" "virtual_machine_admin" {
  name = "Virtual Machine Administrator Login"
}

data "azurerm_role_definition" "virtual_machine_user" {
  name = "Virtual Machine User Login"
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "virtual_machine_admin" {
  scope              = azurerm_resource_group.rg.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.virtual_machine_admin.role_definition_id}"
  principal_id       = local.admin_group
}

resource "azurerm_role_assignment" "virtual_machine_user" {
  scope              = azurerm_resource_group.rg.id
  role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}${data.azurerm_role_definition.virtual_machine_user.role_definition_id}"
  principal_id       = local.user_group
}