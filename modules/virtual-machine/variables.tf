/////////////////////////////////
/// Virtual Machine Variables ///
/////////////////////////////////

variable "ssh_public_keys" {
  description = "List of SSH public keys to add to the papi user"
  type        = list(string)
  default     = []
}

variable "bridge" {
  description = "Network bridge for VM"
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "VLAN tag for VM network interface"
  type        = number
  default     = 20
  nullable    = false # passing null (vlan_id omitted in tfvars) falls back to the default
}

variable "cloud_init_datastore_id" {
  description = "Datastore to use for cloud-init files and images"
  type        = string
  default     = "local"
}

variable "disk_discard" {
  description = "Enable discard on VM disk"
  type        = string
  default     = "on"
}

variable "disk_file_format" {
  description = "Disk file format"
  type        = string
  default     = "raw"
}

variable "disk_interface" {
  description = "Disk interface type"
  type        = string
  default     = "virtio0"
}

variable "disk_iothread" {
  description = "Enable IO thread on VM disk"
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "The Disk size (in GB) for the VM"
  type        = number
}

variable "gateway" {
  description = "IPv4 gateway for VM"
  type        = string
  default     = "10.0.20.1"
}

variable "ip" {
  description = "The IPv4 address and subnet for the VM"
  type        = string
}

variable "memory" {
  description = "Amount of memory (in MB) for the VM"
  type        = number
  default     = 2048
}

variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "node_name" {
  description = "The Proxmox node where the VM will be created"
  type        = string
}

variable "template_vm_id" {
  description = "The VM ID of the template to clone from"
  type        = number
}

variable "vcpu" {
  description = "Number of virtual CPUs for the VM"
  type        = number
  default     = 2
}

variable "vm_datastore_id" {
  description = "Datastore to use for VM disks"
  type        = string
  default     = "rpool"
}
