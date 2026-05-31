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

  ssh_public_keys = var.ssh_public_keys

  template_vm_id = lookup(each.value, "template_vm_id", 0)
}
