data "null_data_source" "vm_outputs" {
  inputs = {
    xdr_tags = join(",", module.vm-bootstrap.*.XDR_TAGS)
  }
}

output "vm_result" {
  value = data.null_data_source.vm_outputs.*.inputs
}