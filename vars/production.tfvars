# Proxmox VMs managed by this repo. Tracked in git and mirrored to public GitHub:
# NO secrets here. The Proxmox API token comes from Vault (secret/proxmox/terraform)
# via ./tf.sh. SSH keys are public keys only.
#
# Changes that need a VM restart (memory, vcpu, ...) are not applied to running VMs:
# restart them one at a time (README: "Changes that need a VM restart").

proxmox_api_url = "https://10.0.10.11:8006/api2/json"
pm_tls_insecure = true

ssh_public_keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHIKtafBF3mKm7dNS1aMykwZpxXyTFY76lBJj2P2GKZ5",
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDpIH3Xz0CrQXfbwGd4WUv+AdrsQXhYBwBJe6cH3COFJwOM+Pmll2FIo+8XDltpjQLPJ0U/V+GQuC0qobYlDSUil3GMPIAdWkrckNWhwAGeuqNDVwPPnZm/k46Y8OuAhx1Udc1IDbUnW4JJupoopZWmTLghdJQ4hUW4jvkBt71pUD3rjvDKQzVKvqUNJrKSFvOvHmFS+yPm1InrZTPHW0k6PvfRyvqWISDpsLd/V3D3CQHDtlzypwbkZBKuLsl1B1aLMH+mZfOIFIlGzD/OBdtGRCR8lPh/DfN5pttnXcaleGQM8zOiSSL5Z9/BA+IpmZdDw6Lp415aosXDh1rHDT7XVRB+P/fUnqxC4V7tc1QBs/poYlOyE53bi6Ru/hkidRmCIgKe+ooU24YL2GQDw2QlRU4q6/fzVl0zah5m0iNV8aQDNilrFtIhSxHwyCpKasF+kbu9p+IxXscD/8wghNCKEA49NxZK0+uYEfTxUsLxXiq5w4ZIB+L6vn5OoxDeTR9WLc7Yt5uVSha+lSwzVYc5bchfUisZs++iG5dE3a68GZXGPRLG0N4tiWueRygR60zlAql8Xi3+htlpixPtmSPfTK0n4YxirlVcWIt6SoAn3Of2XcOam+tj30jV8x/a5sK/HlzL3ykbBho/w0dGa12smoSM77q6uoK1DOGD0iHeQ=="
]

vms = {
  k3s01 = {
    name           = "k3s-prod01"
    node_name      = "proxmox01"
    ip             = "10.0.20.11/24"
    vcpu           = 4
    memory         = 10240
    template_vm_id = 9000
    disk_size      = 100
  }
  k3s02 = {
    name           = "k3s-prod02"
    node_name      = "proxmox02"
    ip             = "10.0.20.12/24"
    vcpu           = 4
    memory         = 10240
    template_vm_id = 9000
    disk_size      = 100
  }
  k3s03 = {
    name           = "k3s-prod03"
    node_name      = "proxmox03"
    ip             = "10.0.20.13/24"
    vcpu           = 4
    memory         = 10240
    template_vm_id = 9000
    disk_size      = 100
  }
}