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

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "windows_vm" {
  name             = "windows-server-01"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "windows-servers"

  num_cpus = 4
  memory   = 8192
  guest_id = "windows9Server64Guest"

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = 100
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name         = "WIN-SERVER-01"
        workgroup             = "WORKGROUP"
        admin_password        = var.windows_admin_password
        auto_logon            = false
        auto_logon_count      = 1
        time_zone             = 35  # (UTC-05:00) Eastern Time (US & Canada)
      }

      network_interface {
        ipv4_address = "192.168.1.100"
        ipv4_netmask = 24
      }

      ipv4_gateway = "192.168.1.1"
      dns_server_list = ["192.168.1.1", "8.8.8.8"]
    }
  }

  annotation = "Windows Server - Managed by Kaveh"
}

output "windows_vm_ip" {
  value = vsphere_virtual_machine.windows_vm.default_ip_address
}
