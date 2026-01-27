# Virtual Machine Resource
resource "vsphere_virtual_machine" "vm" {
  name = var.vm_name
  
  # Resource Pool Configuration
  resource_pool_id = var.resource_pool != "" ? data.vsphere_resource_pool.pool[0].id : data.vsphere_compute_cluster.cluster.resource_pool_id
  
  datastore_id = data.vsphere_datastore.datastore.id
  folder       = var.vm_folder

  # VM Resources
  num_cpus = var.vm_num_cpus
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  # SCSI Controller
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  # Network Interface
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  # Disk Configuration
  disk {
    label            = "disk0"
    size             = max(var.vm_disk_size, data.vsphere_virtual_machine.template.disks[0].size)
    thin_provisioned = var.vm_disk_thin_provisioned
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
  }

  # Clone from Template
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    # Customization Block (Traditional)
    dynamic "customize" {
      for_each = var.use_cloud_init ? [] : [1]
      content {
        linux_options {
          host_name = var.vm_name
          domain    = var.vm_domain
        }

        network_interface {
          ipv4_address = var.vm_ipv4_address != "" ? var.vm_ipv4_address : null
          ipv4_netmask = var.vm_ipv4_address != "" ? var.vm_ipv4_netmask : null
        }

        ipv4_gateway    = var.vm_ipv4_gateway != "" ? var.vm_ipv4_gateway : null
        dns_server_list = var.vm_dns_servers
      }
    }
  }

  # Cloud-Init Configuration (if enabled)
  dynamic "extra_config" {
    for_each = var.use_cloud_init ? [1] : []
    content {
      "guestinfo.metadata"          = base64encode(file(var.cloud_init_metadata_file))
      "guestinfo.metadata.encoding" = "base64"
      "guestinfo.userdata"          = base64encode(file(var.cloud_init_userdata_file))
      "guestinfo.userdata.encoding" = "base64"
    }
  }

  # Annotations
  annotation = var.vm_annotation

  # Wait for guest network
  wait_for_guest_net_timeout = 5

  # Lifecycle
  lifecycle {
    ignore_changes = [
      annotation,
      clone[0].template_uuid,
    ]
  }
}
