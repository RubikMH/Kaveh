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

module "basic_vm" {
  source = "../../modules/vm-single"

  datacenter    = var.datacenter
  datastore     = var.datastore
  cluster       = var.cluster
  host_name     = var.esxi_host_name  # Direct host targeting - bypasses HA/DRS
  networks      = var.networks        # Use multiple networks
  template_name = var.template_name

  vm_name       = "basic-vm-02"
  vm_folder     = ""
  num_cpus      = 2        # Back to 2 CPUs now that HA is fixed
  memory        = 4096     # Back to 4GB RAM
  disk_size     = 30
  
  # ESXi 8.0.3 compatible - use template's hardware version (21)
  firmware         = "bios"
  
  # No cloud-init or customization - just clone from template
  use_cloud_init = false
  
  # No network configuration - VM will use DHCP from template settings
  # Removed: ipv4_address, ipv4_gateway, dns_servers, domain
  
  annotation    = "Basic Debian VM - cloned from template with multiple network interfaces"
}

output "vm_ip" {
  value = module.basic_vm.vm_ip_address
}
