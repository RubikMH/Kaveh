output "vm_id" {
  description = "UUID of the virtual machine"
  value       = vsphere_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = vsphere_virtual_machine.vm.name
}

output "vm_ip_address" {
  description = "Default IP address of the virtual machine"
  value       = vsphere_virtual_machine.vm.default_ip_address
}

output "vm_guest_ip_addresses" {
  description = "All IP addresses of the virtual machine"
  value       = vsphere_virtual_machine.vm.guest_ip_addresses
}

output "vm_uuid" {
  description = "UUID of the virtual machine"
  value       = vsphere_virtual_machine.vm.uuid
}

output "vm_power_state" {
  description = "Power state of the virtual machine"
  value       = vsphere_virtual_machine.vm.power_state
}
