variable "datacenter" {
  description = "vSphere datacenter"
  type        = string
}

variable "datastore" {
  description = "Datastore name"
  type        = string
}

variable "cluster" {
  description = "Cluster name"
  type        = string
}

variable "network" {
  description = "Network name"
  type        = string
}

variable "template_name" {
  description = "VM template name"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for VM names"
  type        = string
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3
}

variable "vm_folder" {
  description = "VM folder path"
  type        = string
  default     = ""
}

variable "num_cpus" {
  description = "Number of CPUs per VM"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB per VM"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Disk size in GB per VM"
  type        = number
  default     = 40
}

variable "thin_provisioned" {
  description = "Use thin provisioning"
  type        = bool
  default     = true
}

variable "use_dhcp" {
  description = "Use DHCP for IP assignment"
  type        = bool
  default     = false
}

variable "ipv4_network_prefix" {
  description = "IPv4 network prefix (e.g., 192.168.1)"
  type        = string
  default     = "192.168.1"
}

variable "ipv4_address_start" {
  description = "Starting IPv4 address (last octet)"
  type        = number
  default     = 10
}

variable "ipv4_netmask" {
  description = "IPv4 netmask"
  type        = number
  default     = 24
}

variable "ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
  default     = ""
}

variable "dns_servers" {
  description = "DNS servers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "domain" {
  description = "Domain name"
  type        = string
  default     = "local"
}

variable "annotation" {
  description = "VM annotation"
  type        = string
  default     = "Managed by Terraform - Cluster"
}
