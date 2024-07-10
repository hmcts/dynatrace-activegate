module "networking" {
  source = "git::https://github.com/hmcts/terraform-module-azure-virtual-networking?ref=main"

  env                          = var.env
  product                      = var.product
  common_tags                  = module.ctags.common_tags
  component                    = var.name
  existing_resource_group_name = azurerm_resource_group.rg.name

  vnets = {
    "${var.name}" = {
      address_space = [var.address_space]
      name_override = "${var.name}-vnet-${var.env}"
      subnets = {
        subnet0 = {
          address_prefixes = [var.address_prefix_subnet0]
          name_override    = "${var.name}-subnet-0-${var.env}"
        }
        subnet1 = {
          address_prefixes = [var.address_prefix_subnet1]
          name_override    = "${var.name}-subnet-1-${var.env}"
        }
      }
    }
  }

  route_tables = {
    rt = {
      subnets       = ["${var.name}-subnet0", "${var.name}-subnet1"]
      name_override = "${var.name}-route-table-${var.env}"
      routes = merge(var.additional_routes, {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = var.next_hop_in_ip_address
        }
      })
    }
  }

  network_security_groups = {
    nsg = {
      subnets       = ["${var.name}-subnet0", "${var.name}-subnet1"]
      name_override = "${var.name}-${var.env}-nsg"
      deny_inbound  = false
      rules = {
      }
    }
  }
}

resource "azurerm_route" "additional_routes_cft_aks_sbox" {
  name                   = "cft-aks-sbox"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = module.networking.route_table_names["rt"]
  address_prefix         = "10.2.8.0/21"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.sbox_next_hop_in_ip_address
}

resource "azurerm_route" "additional_routes_cft_aks_ptlsbox" {
  name                   = "cft-aks-ptlsbox"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = module.networking.route_table_names["rt"]
  address_prefix         = "10.70.24.0/21"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.sbox_next_hop_in_ip_address
}
