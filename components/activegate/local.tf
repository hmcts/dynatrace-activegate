
locals {
  hub = {
    nonprod = {
      subscription = "fb084706-583f-4c9a-bdab-949aac66ba5c"
      ukSouth = {
        name        = "hmcts-hub-nonprodi"
        next_hop_ip = "10.11.72.36"
      }
    }
    sbox = {
      subscription = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
      ukSouth = {
        name        = "hmcts-hub-sbox-int"
        next_hop_ip = "10.10.200.36"
      }
    }
    prod = {
      subscription = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
      ukSouth = {
        name        = "hmcts-hub-prod-int"
        next_hop_ip = "10.11.8.36"
      }
    }
  }

  hubs_to_peer = {
    nonprod = ["sbox", "nonprod"]
    prod    = ["prod"]
  }

  regions = [
    "ukSouth",
  ]

  admin_group = var.env == "prod" ? "6b8ec7d6-93d8-488d-a4b6-62d499b76d19" : "03ebd192-f929-4c52-bbc8-266ec80d3353"
  user_group  = var.env == "prod" ? "26bf2be7-0e5b-442a-9e7b-a1aeddac9803" : "cc7c7005-4284-4af7-8c05-cb4a3b2abd53"

  os_type = var.os_type == null ? substr(var.vm_publisher_name, 0, 9) == "Microsoft" ? "Windows" : "Linux" : var.os_type
  
  local_env = (var.tags.environment == "development" || var.tags.environment == "staging" || var.tags.environment == "testing" || var.tags.environment == "sandbox" || var.tags.environment == "demo" || var.tags.environment == "ithc") ? "nonprod" : "production"
}