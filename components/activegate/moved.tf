moved {
  from = module.vnet.azurerm_route_table.route_table
  to   = module.networking.route_tables.rt
}

moved {
  from = module.vnet.azurerm_subnet_route_table_association.subnet_00
  to   = "module.networking.route_tables.rt.subnets.${var.name}-subnet0"
}

moved {
  from = module.vnet.azurerm_subnet_route_table_association.subnet_01
  to   = "module.networking.route_tables.rt.subnets.${var.name}-subnet1"
}