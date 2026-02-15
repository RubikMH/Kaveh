terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.6"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

# Deploy cluster of 5 VMs with multiple network interfaces
module "vm_cluster" {
  source = "../../modules/vm-cluster"

  datacenter    = var.datacenter
  datastore     = var.datastore
  cluster       = var.cluster
  networks      = var.networks        # Multiple network interfaces
  template_name = var.template_name

  # Cluster configuration
  name_prefix = var.name_prefix
  vm_count    = var.vm_count
  vm_folder   = ""
  
  # Resource allocation per VM
  num_cpus  = var.num_cpus
  memory    = var.memory
  disk_size = var.disk_size
  
  # Network configuration
  use_dhcp             = var.use_dhcp
  ipv4_network_prefix  = var.ipv4_network_prefix
  ipv4_address_start   = var.ipv4_address_start
  ipv4_gateway         = var.ipv4_gateway
  dns_servers          = var.dns_servers
  domain               = var.domain
  
  annotation = "Managed by Terraform - 5 VM Cluster with Multiple Network Interfaces"
}

# Output information about the created VMs
output "vm_names" {
  description = "Names of all created VMs"
  value       = module.vm_cluster.vm_names
}

output "vm_ip_addresses" {
  description = "IP addresses of all created VMs"
  value       = module.vm_cluster.vm_ip_addresses
}

output "cluster_info" {
  description = "Summary of the created cluster"
  value = {
    vm_count        = var.vm_count
    name_prefix     = var.name_prefix
    network_count   = length(var.networks)
    networks        = [for net in var.networks : net.name]
    resource_per_vm = {
      cpus   = var.num_cpus
      memory = "${var.memory}MB"
      disk   = "${var.disk_size}GB"
    }
  }
}
