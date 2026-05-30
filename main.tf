module "virtual_machines" {
  source = "./modules/virtual-machine"

  providers = {
    proxmox = proxmox
  }

  for_each = var.vms

  name      = each.value.name
  node_name = each.value.node_name
  ip        = each.value.ip
  vcpu      = each.value.vcpu
  memory    = each.value.memory
  disk_size = each.value.disk_size

  # Network
  vlan_id = lookup(each.value, "vlan_id", null)

  # SSH / cloud-init users
  ssh_username         = lookup(each.value, "ssh_username", "papi")
  ssh_public_key_path  = lookup(each.value, "ssh_public_key_path", "./id_ed25519.pub")
  ssh_additional_users = lookup(each.value, "ssh_additional_users", [])

  template_vm_id = lookup(each.value, "template_vm_id", 0)
}
