moved {
  from = module.nsg.azurerm_network_security_group.network_security_group
  to   = module.networking.azurerm_network_security_group.this["nsg"]
}

moved {
  from = azurerm_route_table.route_table
  to   = module.networking.azurerm_route_table.this["rt"]
}

moved {
  from = module.vnet.azurerm_resource_group.rg
  to   = azurerm_resource_group.rg
}

moved {
  from = module.vnet.azurerm_subnet.sb[0]
  to   = module.networking.azurerm_subnet.this["dynatrace-activegate-subnet0"]
}

moved {
  from = module.vnet.azurerm_subnet.sb[1]
  to   = module.networking.azurerm_subnet.this["dynatrace-activegate-subnet1"]
}

# moved {
#   from =
#   to   = module.networking.azurerm_route.this["rt-default"]
# }

# moved {
#   from =
#   to   = module.networking.azurerm_route_table.this["rt"]
# }


moved {
  from = module.nsg.azurerm_subnet_network_security_group_association.subnet_association["dynatrace-activegate-subnet-0-prod"]
  to   = module.networking.azurerm_subnet_network_security_group_association.this["nsg-dynatrace-activegate-subnet0"]
}

moved {
  from = module.nsg.azurerm_subnet_network_security_group_association.subnet_association["dynatrace-activegate-subnet-1-prod"]
  to   = module.networking.azurerm_subnet_network_security_group_association.this["nsg-dynatrace-activegate-subnet1"]
}

moved {
  from = azurerm_subnet_route_table_association.subnet_00
  to   = module.networking.azurerm_subnet_route_table_association.this["rt-dynatrace-activegate-subnet0"]
}

moved {
  from = azurerm_subnet_route_table_association.subnet_01
  to   = module.networking.azurerm_subnet_route_table_association.this["rt-dynatrace-activegate-subnet1"]
}

moved {
  from = module.vnet.azurerm_virtual_network.vnet
  to   = module.networking.azurerm_virtual_network.this["dynatrace-activegate"]
}
