// terraform doesn't let you have undeclared vars used from a tfvars file but no variable declaration
// we link this file into each component
// from the component dir: `ln -s ../../environments/variables.tf variables.tf`

variable "subscription" {
  default = []
}

variable "key_vault_subscription" {
  default = []
}

variable "env" {
  default = []
}

variable "project" {
  default = "hmcts"
}

variable "product" {
}
