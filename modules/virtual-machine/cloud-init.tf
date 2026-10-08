# Cloud-init user-data file (must use file-based datastore, e.g., 'local').
# qemu-guest-agent is baked into the template, so no package installs here.
resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.cloud_init_datastore_id
  node_name    = var.node_name

  source_raw {
    data      = <<-EOF
#cloud-config
    hostname: ${var.name}
    timezone: America/New_York
    users:
      - default
      - name: papi
        groups:
          - sudo
          - _ssh
        shell: /bin/bash
        ssh_authorized_keys:
%{for key in var.ssh_public_keys~}
          - ${trimspace(key)}
%{endfor~}
        sudo: ALL=(ALL) NOPASSWD:ALL
    runcmd:
      - echo "done" > /tmp/cloud-config.done
    EOF
    file_name = "user-data-${var.name}.yaml"
  }

  # cloud-init only runs on a VM's first boot. Without this, any later edit here (e.g.
  # an SSH key) replaces the snippet, which forces Terraform to destroy and recreate
  # the VM. New VMs still get the current content; keys on existing VMs are changed
  # on the VMs themselves (Ansible), not here.
  lifecycle {
    ignore_changes = [source_raw]
  }
}
