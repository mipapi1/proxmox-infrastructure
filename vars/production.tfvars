proxmox_api_url      = "https://192.168.1.70:8006/api2/json"
proxmox_api_token_id = "terraform-prov@pve!terraform-provisioner=10ecdc17-822f-45d6-986f-4b115027bf34"
pm_tls_insecure = true

vms = {
  vault = {
    name                        = "vault-prod01"
    vm_id                       = 108
    node_name                   = "proxmox03"
    ip                          = "192.168.1.36/22"
    vcpu                        = 1
    memory                      = 2048
    template_vm_id              = 0
    disk_size                   = 64  
  }
}
