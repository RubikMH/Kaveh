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

# Optional specific host data source (bypasses HA/DRS)
data "vsphere_host" "host" {
  count         = var.host_name != null ? 1 : 0
  name          = var.host_name
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

# Virtual Machine
resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = var.host_name != null ? data.vsphere_host.host[0].resource_pool_id : data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder

  num_cpus = var.num_cpus
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  # Hardware compatibility settings
  hardware_version     = var.hardware_version != null ? var.hardware_version : data.vsphere_virtual_machine.template.hardware_version
  firmware             = var.firmware != null ? var.firmware : data.vsphere_virtual_machine.template.firmware
  scsi_type           = data.vsphere_virtual_machine.template.scsi_type
  
  # CPU compatibility settings for Intel Xeon processors
  cpu_hot_add_enabled    = false
  cpu_hot_remove_enabled = false
  memory_hot_add_enabled = false
  
  # Force older CPU features for maximum compatibility
  cpu_performance_counters_enabled = false
  nested_hv_enabled                = false
  ept_rvi_mode                     = "automatic"
  hv_mode                          = "hvAuto"
  
  # Disable newer features that might cause compatibility issues
  enable_disk_uuid                 = false
  sync_time_with_host_periodically = false
  
  # Ensure VM waits for network and tools
  wait_for_guest_net_timeout = 0  # Disable network waiting
  wait_for_guest_ip_timeout  = 0  # Disable IP waiting
  wait_for_guest_net_routable = false  # Don't wait for routable network

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

  # Cloud-Init Configuration (via extra_config)
  extra_config = var.use_cloud_init ? {
    "guestinfo.metadata"          = var.cloud_init_metadata
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = var.cloud_init_userdata
    "guestinfo.userdata.encoding" = "base64"
  } : {}

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    dynamic "customize" {
      # Only customize if cloud-init is disabled AND network settings are provided
      for_each = (!var.use_cloud_init && var.ipv4_address != null && var.ipv4_address != "") ? [1] : []
      content {
        linux_options {
          host_name = var.vm_name
          domain    = var.domain
        }

        # Network interface customization for single network (backward compatibility)
        dynamic "network_interface" {
          for_each = var.network != null ? [1] : []
          content {
            ipv4_address = var.ipv4_address
            ipv4_netmask = var.ipv4_netmask
          }
        }

        # Network interface customization for multiple networks
        dynamic "network_interface" {
          for_each = var.networks
          content {
            ipv4_address = network_interface.value.ipv4_address
            ipv4_netmask = network_interface.value.ipv4_netmask
          }
        }

        ipv4_gateway    = var.ipv4_gateway
        dns_server_list = var.dns_servers
      }
    }
  }

  annotation = var.annotation
}
