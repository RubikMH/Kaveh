output "vm_id" {
  description = "VM ID"
  value       = vsphere_virtual_machine.vm.id
}

output "vm_name" {
  description = "VM name"
  value       = vsphere_virtual_machine.vm.name
}

output "vm_ip_address" {
  description = "VM IP address"
  value       = vsphere_virtual_machine.vm.default_ip_address
}

output "vm_uuid" {
  description = "VM UUID"
  value       = vsphere_virtual_machine.vm.uuid
}
