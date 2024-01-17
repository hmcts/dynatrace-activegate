module "vnet" {
  source                = "git::https://github.com/hmcts/cnp-module-vnet?ref=master"
  name                  = var.name
  location              = var.location
  address_space         = var.address_space
  source_range          = var.address_space
  env                   = var.env
  lb_private_ip_address = cidrhost(cidrsubnet(var.address_space, 4, 2), -2)
  subnet_count          = var.subnet_count
  subnet_prefix_length  = var.subnet_prefix_length
  common_tags           = module.ctags.common_tags
}

resource "azurerm_route_table" "route_table" {
  name                = "${var.name}-route-table-${var.env}"
  location            = var.location
  resource_group_name = module.vnet.resourcegroup_name

  route {
    name                   = "10_0_0_0"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.next_hop_in_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "subnet_00" {
  subnet_id      = module.vnet.subnet_ids[0]
  route_table_id = azurerm_route_table.route_table.id
}

resource "azurerm_subnet_route_table_association" "subnet_01" {
  subnet_id      = module.vnet.subnet_ids[1]
  route_table_id = azurerm_route_table.route_table.id
}