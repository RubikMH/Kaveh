terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.6"
    }
  }
}

# Data Sources
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

# Data source for single network (backward compatibility)
data "vsphere_network" "network" {
  count         = var.network != null ? 1 : 0
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Data sources for multiple networks
data "vsphere_network" "networks" {
  count         = length(var.networks)
  name          = var.networks[count.index].name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Virtual Machine Cluster
resource "vsphere_virtual_machine" "vms" {
  count = var.vm_count

  name             = "${var.name_prefix}-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder

  num_cpus = var.num_cpus
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  # Network interface for backward compatibility (single network)
  dynamic "network_interface" {
    for_each = var.network != null ? [1] : []
    content {
      network_id   = data.vsphere_network.network[0].id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }

  # Network interfaces for multiple networks
  dynamic "network_interface" {
    for_each = var.networks
    content {
      network_id   = data.vsphere_network.networks[network_interface.key].id
      adapter_type = length(data.vsphere_virtual_machine.template.network_interface_types) > network_interface.key ? data.vsphere_virtual_machine.template.network_interface_types[network_interface.key] : data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }

  disk {
    label            = "disk0"
    size             = var.disk_size
    thin_provisioned = var.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.name_prefix}-${count.index + 1}"
        domain    = var.domain
      }

        # Network interface customization for single network (backward compatibility)
        dynamic "network_interface" {
          for_each = var.network != null ? [1] : []
          content {
            ipv4_address = var.use_dhcp ? null : "${var.ipv4_network_prefix}.${var.ipv4_address_start + count.index}"
            ipv4_netmask = var.use_dhcp ? null : var.ipv4_netmask
          }
        }

        # Network interface customization for multiple networks
        dynamic "network_interface" {
          for_each = var.networks
          content {
            ipv4_address = var.use_dhcp ? null : "${var.ipv4_network_prefix}.${var.ipv4_address_start + count.index + network_interface.key * 100}"
            ipv4_netmask = var.use_dhcp ? null : var.ipv4_netmask
          }
        }

      ipv4_gateway    = var.use_dhcp ? null : var.ipv4_gateway
      dns_server_list = var.dns_servers
    }
  }

  annotation = "${var.annotation} - Node ${count.index + 1}"
}
