module "nsg" {
  source = "git::https://github.com/hmcts/terraform-module-network-security-group.git?ref=DTSPO_16117"

  network_security_group_name = "dynatrace-activegate-${var.env}-nsg"
  resource_group_name         = module.vnet.resourcegroup_name
  location                    = "uksouth"

  subnet_ids = {
    "${module.vnet.subnet_names[0]}" = module.vnet.subnet_ids[0]
    "${module.vnet.subnet_names[1]}" = module.vnet.subnet_ids[1]
  }
}