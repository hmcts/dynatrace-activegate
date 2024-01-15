# module "vnet_peer_hub_sbox" {
#   for_each = toset([for r in local.regions : r if contains(local.hubs_to_peer[var.env], "nonprod")])
#   source   = "github.com/hmcts/terraform-module-vnet-peering"

#   peerings = {
#     source = {
#       name           = "hub"
#       vnet           = module.vnet.vnetname
#       resource_group = module.vnet.resourcegroup_name
#     }
#     target = {
#       name           = format("%s%s", var.project, var.env)
#       vnet           = local.hub["sbox"][each.key].name
#       resource_group = local.hub["sbox"][each.key].name
#     }
#   }

#   providers = {
#     azurerm.initiator = azurerm
#     azurerm.target    = azurerm.hub-sbox
#   }
# }

# module "vnet_peer_hub_nonprod" {
#   for_each = toset([for r in local.regions : r if contains(local.hubs_to_peer[var.env], "nonprod")])
#   source   = "github.com/hmcts/terraform-module-vnet-peering"

#   peerings = {
#     source = {
#       name           = "hub"
#       vnet           = module.vnet.vnetname
#       resource_group = module.vnet.resourcegroup_name
#     }
#     target = {
#       name           = format("%s%s", var.project, var.env)
#       vnet           = local.hub["nonprod"][each.key].name
#       resource_group = local.hub["nonprod"][each.key].name
#     }
#   }

#   providers = {
#     azurerm.initiator = azurerm
#     azurerm.target    = azurerm.hub-nonprod
#   }
# }

# module "vnet_peer_hub_prod" {
#   for_each = toset([for r in local.regions : r if contains(local.hubs_to_peer[var.env], "prod")])
#   source   = "github.com/hmcts/terraform-module-vnet-peering"

#   peerings = {
#     source = {
#       name           = "hub"
#       vnet           = module.vnet.vnetname
#       resource_group = module.vnet.resourcegroup_name
#     }
#     target = {
#       name           = format("%s%s", var.project, var.env)
#       vnet           = local.hub["prod"][each.key].name
#       resource_group = local.hub["prod"][each.key].name
#     }
#   }

#   providers = {
#     azurerm.initiator = azurerm
#     azurerm.target    = azurerm.hub-prod
#   }
# }