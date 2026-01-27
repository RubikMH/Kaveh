output "vm_ids" {
  description = "List of VM IDs"
  value       = vsphere_virtual_machine.vms[*].id
}

output "vm_names" {
  description = "List of VM names"
  value       = vsphere_virtual_machine.vms[*].name
}

output "vm_ip_addresses" {
  description = "List of VM IP addresses"
  value       = vsphere_virtual_machine.vms[*].default_ip_address
}

output "vm_uuids" {
  description = "List of VM UUIDs"
  value       = vsphere_virtual_machine.vms[*].uuid
}
