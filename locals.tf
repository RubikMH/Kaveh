# Local Values for Kaveh vSphere Automation
# Computed values and data transformations for better code organization

locals {
  # ============================================
  # VM Naming and Identification
  # ============================================

  # Sanitized VM name (removes special characters, enforces lowercase)
  vm_name_sanitized = lower(replace(var.vm_name, "/[^a-zA-Z0-9-]/", "-"))

  # Full hostname with domain
  vm_fqdn = "${var.vm_name}.${var.vm_domain}"

  # ============================================
  # Resource Identification
  # ============================================

  # Resource pool ID - uses cluster default if not specified
  resource_pool_id = var.resource_pool != "" ? data.vsphere_resource_pool.pool[0].id : data.vsphere_compute_cluster.cluster.resource_pool_id

  # ============================================
  # Network Configuration
  # ============================================

  # Determine if using static IP or DHCP
  use_static_ip = var.vm_ipv4_address != ""

  # Network configuration for customization
  network_config = local.use_static_ip ? {
    ipv4_address = var.vm_ipv4_address
    ipv4_netmask = var.vm_ipv4_netmask
    ipv4_gateway = var.vm_ipv4_gateway
  } : null

  # ============================================
  # Disk Configuration
  # ============================================

  # Ensure disk size is at least as large as the template
  effective_disk_size = max(var.vm_disk_size, data.vsphere_virtual_machine.template.disks[0].size)

  # ============================================
  # Cloud-Init Configuration
  # ============================================

  # Cloud-init extra_config map
  cloud_init_config = var.use_cloud_init ? {
    "guestinfo.metadata"          = base64encode(file(var.cloud_init_metadata_file))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(file(var.cloud_init_userdata_file))
    "guestinfo.userdata.encoding" = "base64"
  } : {}

  # ============================================
  # Annotations and Metadata
  # ============================================

  # Standard annotation with timestamp and management info
  default_annotation = "Managed by Terraform - Kaveh | Created: ${timestamp()}"

  # Final annotation (use custom if provided, otherwise default)
  vm_annotation = var.vm_annotation != "" ? var.vm_annotation : local.default_annotation

  # ============================================
  # Tags
  # ============================================

  # Common tags applied to all resources
  common_tags = {
    managed_by  = "terraform"
    project     = "kaveh"
    environment = terraform.workspace
  }

  # Merged tags (common + user-provided)
  all_tags = merge(local.common_tags, var.vm_tags)

  # ============================================
  # Validation Helpers
  # ============================================

  # Check if IP address format is valid (basic check)
  is_valid_ipv4 = var.vm_ipv4_address == "" || can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", var.vm_ipv4_address))

  # Check if gateway is provided when static IP is used
  gateway_required = local.use_static_ip && var.vm_ipv4_gateway == ""
}
