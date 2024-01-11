module "vnet" {
  source                = "git::https://github.com/hmcts/cnp-module-vnet?ref=master"
  name                  = var.name
  location              = var.location
  address_space         = var.address_space
  source_range          = var.address_space
  env                   = var.env
  lb_private_ip_address = cidrhost(cidrsubnet(var.address_space, 4, 2), -2)
  subnet_count          = var.subnet_count
}
