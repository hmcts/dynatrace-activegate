module "networking" {
  source = "git::https://github.com/hmcts/terraform-module-azure-virtual-networking?ref=main"

  env                          = var.env
  product                      = var.product
  common_tags                  = module.ctags.common_tags
  component                    = var.name
  existing_resource_group_name = "${var.name}-${var.env}"

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
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = var.next_hop_in_ip_address
        }
      }
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