terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.98.1"
    }
  }
}

resource "proxmox_virtual_environment_vm" "virtual_machine" {
  depends_on = [
    proxmox_virtual_environment_file.cloud_config
  ]

  name      = var.name
  node_name = var.node_name

  clone {
    vm_id     = var.template_vm_id
    node_name = "proxmox01"
    full      = true # full clone — required for shared NFS storage
    # Same node as the template: clone straight to local storage. Other nodes:
    # Proxmox can't clone cross-node to non-shared storage, so it lands on the
    # template's shared NAS storage and the disk block below moves it to local.
    datastore_id = var.node_name == "proxmox01" ? var.vm_datastore_id : null
  }

  machine       = "q35"             # matches new template
  bios          = "ovmf"            # matches new template (UEFI)
  scsi_hardware = "virtio-scsi-pci" # matches new template scsihw

  efi_disk {
    datastore_id = var.vm_datastore_id
    file_format  = "raw"
    type         = "4m"
  }

  serial_device {
    device = "socket"
  }

  agent {
    enabled = true
    timeout = "120s"
  }

  cpu {
    cores = var.vcpu
    type  = "host" # matches new template cpu type
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.vm_datastore_id
    interface    = var.disk_interface # virtio0
    iothread     = var.disk_iothread
    file_format  = var.disk_file_format # raw
    discard      = var.disk_discard
    size         = var.disk_size
  }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    datastore_id      = var.cloud_init_datastore_id
    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }
  }

  network_device {
    bridge  = var.bridge
    vlan_id = var.vlan_id
  }
}