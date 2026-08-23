output "id" {
  description = "Terraform resource ID of the VM."
  value       = proxmox_vm_qemu.your-vm.id
}

output "vmid" {
  description = "Proxmox numeric VM ID."
  value       = proxmox_vm_qemu.your-vm.vmid
}

output "name" {
  description = "Full VM name, built from env, name and agent."
  value       = proxmox_vm_qemu.your-vm.name
}

output "default_ipv4_address" {
  description = "First IPv4 address the guest agent reports. Empty until the agent answers."
  value       = proxmox_vm_qemu.your-vm.default_ipv4_address
}

output "ssh_host" {
  description = "Host that Proxmox reports for SSH."
  value       = proxmox_vm_qemu.your-vm.ssh_host
}

output "ssh_port" {
  description = "Port that Proxmox reports for SSH."
  value       = proxmox_vm_qemu.your-vm.ssh_port
}
