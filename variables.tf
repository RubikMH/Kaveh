# vSphere Connection Variables
variable "vsphere_user" {
  description = "vSphere username"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.vsphere_user) > 0
    error_message = "vSphere username cannot be empty."
  }
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.vsphere_password) >= 8
    error_message = "vSphere password must be at least 8 characters long."
  }
}

variable "vsphere_server" {
  description = "vSphere server FQDN or IP address"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]+[a-zA-Z0-9]$", var.vsphere_server))
    error_message = "vSphere server must be a valid FQDN or IP address."
  }
}

variable "allow_unverified_ssl" {
  description = "Allow unverified SSL certificates (set to false in production)"
  type        = bool
  default     = false
}

# vSphere Infrastructure Variables
variable "datacenter" {
  description = "vSphere datacenter name"
  type        = string

  validation {
    condition     = length(var.datacenter) > 0
    error_message = "Datacenter name cannot be empty."
  }
}

variable "datastore" {
  description = "Datastore name for VM storage"
  type        = string

  validation {
    condition     = length(var.datastore) > 0
    error_message = "Datastore name cannot be empty."
  }
}

variable "cluster" {
  description = "vSphere cluster name"
  type        = string

  validation {
    condition     = length(var.cluster) > 0
    error_message = "Cluster name cannot be empty."
  }
}

variable "network" {
  description = "Network name for VM"
  type        = string

  validation {
    condition     = length(var.network) > 0
    error_message = "Network name cannot be empty."
  }
}

variable "resource_pool" {
  description = "Resource pool name (optional, uses cluster default if not specified)"
  type        = string
  default     = ""
}

# VM Template Variable
variable "template_name" {
  description = "Name of the VM template to clone from"
  type        = string
}

# VM Configuration Variables
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "kaveh-vm"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,62}$", var.vm_name))
    error_message = "VM name must start with a letter, contain only alphanumeric characters and hyphens, and be max 63 characters."
  }
}

variable "vm_folder" {
  description = "Folder path for the VM (optional)"
  type        = string
  default     = ""
}

variable "vm_num_cpus" {
  description = "Number of CPUs for the VM"
  type        = number
  default     = 2

  validation {
    condition     = var.vm_num_cpus >= 1 && var.vm_num_cpus <= 128
    error_message = "Number of CPUs must be between 1 and 128."
  }
}

variable "vm_memory" {
  description = "Memory size in MB for the VM"
  type        = number
  default     = 4096

  validation {
    condition     = var.vm_memory >= 512 && var.vm_memory <= 6291456
    error_message = "Memory must be between 512 MB and 6 TB (6291456 MB)."
  }

  validation {
    condition     = var.vm_memory % 4 == 0
    error_message = "Memory must be a multiple of 4 MB."
  }
}

variable "vm_disk_size" {
  description = "Disk size in GB for the VM"
  type        = number
  default     = 40

  validation {
    condition     = var.vm_disk_size >= 1 && var.vm_disk_size <= 62000
    error_message = "Disk size must be between 1 GB and 62 TB."
  }
}

variable "vm_disk_thin_provisioned" {
  description = "Use thin provisioning for VM disk"
  type        = bool
  default     = true
}

# Network Configuration
variable "vm_ipv4_address" {
  description = "IPv4 address for the VM (leave empty for DHCP)"
  type        = string
  default     = ""

  validation {
    condition     = var.vm_ipv4_address == "" || can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", var.vm_ipv4_address))
    error_message = "IPv4 address must be a valid IP address format (e.g., 192.168.1.100)."
  }
}

variable "vm_ipv4_netmask" {
  description = "IPv4 netmask (number of bits)"
  type        = number
  default     = 24

  validation {
    condition     = var.vm_ipv4_netmask >= 1 && var.vm_ipv4_netmask <= 32
    error_message = "IPv4 netmask must be between 1 and 32 bits."
  }
}

variable "vm_ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
  default     = ""

  validation {
    condition     = var.vm_ipv4_gateway == "" || can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", var.vm_ipv4_gateway))
    error_message = "IPv4 gateway must be a valid IP address format."
  }
}

variable "vm_dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]

  validation {
    condition     = length(var.vm_dns_servers) > 0
    error_message = "At least one DNS server must be specified."
  }
}

variable "vm_domain" {
  description = "Domain name for the VM"
  type        = string
  default     = "local"

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9]$", var.vm_domain)) || var.vm_domain == "local"
    error_message = "Domain must be a valid domain name format."
  }
}

# Cloud-Init Configuration
variable "use_cloud_init" {
  description = "Enable cloud-init configuration"
  type        = bool
  default     = false
}

variable "cloud_init_metadata_file" {
  description = "Path to cloud-init metadata file"
  type        = string
  default     = "cloud-init/metadata.yaml"
}

variable "cloud_init_userdata_file" {
  description = "Path to cloud-init userdata file"
  type        = string
  default     = "cloud-init/userdata.yaml"
}

# Tags and Annotations
variable "vm_tags" {
  description = "Map of tags to apply to the VM"
  type        = map(string)
  default     = {}
}

variable "vm_annotation" {
  description = "Annotation/notes for the VM"
  type        = string
  default     = "Managed by Terraform - Kaveh"
}
