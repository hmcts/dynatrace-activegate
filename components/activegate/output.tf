output "XDR_TAGS" {
  value = { for k, v in module.vm-bootstrap : k => v.XDR_TAGS }
}