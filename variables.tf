# vSphere Connection Variables
variable "vsphere_user" {
  description = "vSphere username"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server FQDN or IP address"
  type        = string
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
}

variable "datastore" {
  description = "Datastore name for VM storage"
  type        = string
}

variable "cluster" {
  description = "vSphere cluster name"
  type        = string
}

variable "network" {
  description = "Network name for VM"
  type        = string
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
}

variable "vm_memory" {
  description = "Memory size in MB for the VM"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "Disk size in GB for the VM"
  type        = number
  default     = 40
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
}

variable "vm_ipv4_netmask" {
  description = "IPv4 netmask (number of bits)"
  type        = number
  default     = 24
}

variable "vm_ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
  default     = ""
}

variable "vm_dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "vm_domain" {
  description = "Domain name for the VM"
  type        = string
  default     = "local"
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
