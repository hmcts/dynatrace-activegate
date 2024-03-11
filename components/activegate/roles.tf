data "azuread_group" "admin_access" {
  display_name     = var.env == prod ? "DTS Production Dynatrace ActiveGate Access for Administrators" : "DTS Non-Production Dynatrace ActiveGate Access for Administrators"
  security_enabled = true
}
data "azuread_group" "user_access" {
  display_name     = var.env == prod ? "DTS Production Dynatrace ActiveGate Access for Users" : "DTS Non-Production Dynatrace ActiveGate Access for Users"
  security_enabled = true
}

data "azurerm_role_definition" "virtual_machine_admin" {
  name = "Virtual Machine Administrator Login"
}

data "azurerm_role_definition" "virtual_machine_user" {
  name = "Virtual Machine User Login"
}

resource "azurerm_role_assignment" "virtual_machine_admin" {
  name               = "Virtual Machine Administrator Login"
  scope              = azurerm_resource_group.rg.id
  role_definition_id = data.azurerm_role_definition.virtual_machine_admin.role_definition_id
  principal_id       = data.azuread_group.admin_access.id
}

resource "azurerm_role_assignment" "virtual_machine_user" {
  name               = "Virtual Machine User Login"
  scope              = azurerm_resource_group.rg.id
  role_definition_id = data.azurerm_role_definition.virtual_machine_user.role_definition_id
  principal_id       = data.azuread_group.user_access.id
}