variable "env" {
  description = "Environment prefix in the VM name. Example: dev, prod."
  type        = string
}

variable "target_node" {
  description = "Proxmox node that holds the VM. Example: pve."
  type        = string
}

variable "agent" {
  description = "Instance number, used as the last part of the VM name."
  type        = string
}

variable "name" {
  description = "Role part of the VM name. Example: ansible-builder."
  type        = string
}

variable "size" {
  description = "Size of the virtio0 disk, with a unit. Example: 20G."
  type        = string
}

variable "clone" {
  description = "Name of the Proxmox template to clone."
  type        = string
}

variable "cores" {
  description = "Number of CPU cores."
  type        = number
}

variable "memory" {
  description = "Memory in MiB. Example: 2048."
  type        = number
}

variable "ipconfig0" {
  description = "Cloud-init network line. Example: ip=10.0.0.10/24,gw=10.0.0.1."
  type        = string
}

variable "ciuser" {
  description = "Default cloud-init user."
  type        = string
}
