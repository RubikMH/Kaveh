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
  network       = var.network
  template_name = var.template_name

  vm_name       = "basic-vm-01"
  vm_folder     = "examples"
  num_cpus      = 2
  memory        = 4096
  disk_size     = 40
  
  ipv4_address  = "192.168.1.50"
  ipv4_gateway  = "192.168.1.1"
  dns_servers   = ["8.8.8.8"]
  domain        = "example.local"
  
  annotation    = "Basic VM example from Kaveh"
}

output "vm_ip" {
  value = module.basic_vm.vm_ip_address
}
