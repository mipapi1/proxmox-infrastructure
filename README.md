# proxmox-infrastructure

Terraform modules for declaratively provisioning virtual machines on Proxmox using cloud-init. VMs are full clones of a prepared Ubuntu template (UEFI/q35, qemu-guest-agent installed).

## Prerequisites

- **Template VM** (default ID `9000`) on `proxmox01`, stored on the shared `proxmox-nas` NFS storage so it can be cloned to any node.
- **`snippets` content** enabled on the `local` storage of every node (cloud-init user-data is uploaded there).
- **API token** for `terraform-prov@pve`, stored in Vault at `secret/proxmox/terraform` (key `api-token`, value `terraform-prov@pve!terraform-provisioner=<secret>`).
- **Proxmox permissions** for `terraform-prov@pve`:
  - role `TerraformProv` on `/vms`, `/storage/local`, `/storage/rpool`, `/nodes`, `/sdn/zones/localnetwork`
  - role `PVEDatastoreUser` on `/storage/proxmox-nas` (cross-node clones are staged there)
- **Root SSH** to the Proxmox nodes with `~/.ssh/id_ed25519` (the provider uploads snippets over SSH).
- `terraform` and `vault` CLIs.

## Usage

1. Copy the example vars file and fill in your values:

```bash
cp vars/production.tfvars.example vars/production.tfvars
```

2. Edit `vars/production.tfvars` with your SSH public keys and VM definitions. The API token is **not** stored here.

3. Init and apply through the wrapper, which reads the token from Vault and adds the var file:

```bash
terraform init
./tf.sh plan
./tf.sh apply
```

`tf.sh` reuses your existing Vault login (`~/.vault-token`) and prompts for a userpass login if it can't read the secret. `VAULT_ADDR` defaults to `https://vault.agathla.com`.

## Variables

| Variable | Description |
|---|---|
| `proxmox_api_url` | Proxmox API URL (e.g. `https://10.0.0.1:8006/api2/json`) |
| `proxmox_api_token_id` | Proxmox API token — supplied by `tf.sh` from Vault, never put in tfvars |
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
| `vcpu` | yes | — | Number of vCPUs |
| `memory` | yes | — | RAM in MB |
| `disk_size` | yes | — | Disk size in GB |
| `template_vm_id` | yes | — | VM ID of the template to clone (e.g. `9000`) |
| `vlan_id` | no | `20` | VLAN tag |

```hcl
vms = {
  k3s01 = {
    name           = "k3s-prod01"
    node_name      = "proxmox01"
    ip             = "10.0.20.11/24"
    vcpu           = 4
    memory         = 8192
    disk_size      = 100
    template_vm_id = 9000
  }
}
```

VMs on `proxmox01` (the template's node) clone straight to local `rpool` storage (~45s). VMs on other nodes are cloned via the shared NAS and then moved to `rpool` (~3 min), because Proxmox can't clone cross-node directly to non-shared storage.

## State

State is local (`terraform.tfstate`, gitignored) — one state per checkout. Don't reuse the same checkout with a different tfvars file for another set of VMs: Terraform would plan to destroy the VMs from the previous file.
