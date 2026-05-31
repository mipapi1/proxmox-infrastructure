# proxmox-infrastructure

Terraform modules for declaratively provisioning virtual machines on Proxmox using cloud-init. VMs are created by downloading an Ubuntu Noble cloud image — no pre-existing template required.

## Usage

1. Copy the example vars file and fill in your values:

```bash
cp vars/production.tfvars.example vars/production.tfvars
```

2. Edit `vars/production.tfvars` with your Proxmox credentials, SSH public keys, and VM definitions.

3. Init and apply:

```bash
terraform init
terraform apply -var-file=vars/production.tfvars
```

## Variables

| Variable | Description |
|---|---|
| `proxmox_api_url` | Proxmox API URL (e.g. `https://10.0.0.1:8006/api2/json`) |
| `proxmox_api_token_id` | Proxmox API token (`user@realm!tokenid=...`) |
| `pm_tls_insecure` | Skip TLS verification |
| `ssh_public_keys` | List of SSH public keys added to the `papi` user on every VM |
| `vms` | Map of VMs to provision (see example below) |

## SSH Keys

Add one or more public keys to `ssh_public_keys` in your tfvars. All keys are injected into the `papi` user via cloud-init — no local key file needed.

```hcl
ssh_public_keys = [
  "ssh-ed25519 AAAA... user@host",
  "ssh-rsa AAAA... another@host",
]
```

## VM Definition

Each entry in the `vms` map supports:

| Field | Required | Default | Description |
|---|---|---|---|
| `name` | yes | — | VM hostname |
| `node_name` | yes | — | Proxmox node to create the VM on |
| `ip` | yes | — | Static IP with prefix (e.g. `10.0.20.10/24`) |
| `vcpu` | no | `2` | Number of vCPUs |
| `memory` | no | `2048` | RAM in MB |
| `disk_size` | yes | — | Disk size in GB |
| `vlan_id` | no | `null` | VLAN tag (omit for untagged) |
| `template_vm_id` | no | `0` | Clone from template instead of downloading image |

```hcl
vms = {
  vault = {
    name      = "vault-prod01"
    node_name = "proxmox03"
    ip        = "10.0.20.36/24"
    vcpu      = 1
    memory    = 2048
    disk_size = 64
    vlan_id   = 20
  }
}
```
