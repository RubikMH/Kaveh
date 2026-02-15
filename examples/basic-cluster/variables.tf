variable "vsphere_user" {
  type      = string
  sensitive = true
}

variable "vsphere_password" {
  type      = string
  sensitive = true
}

variable "vsphere_server" {
  type = string
}

variable "datacenter" {
  type = string
}

variable "datastore" {
  type = string
}

variable "cluster" {
  type = string
}

variable "network" {
  description = "Network name (for single network - use networks for multiple interfaces)"
  type        = string
  default     = null
}

variable "networks" {
  description = "List of network configurations for multiple network interfaces"
  type = list(object({
    name         = string
    ipv4_address = optional(string)
    ipv4_netmask = optional(number, 24)
  }))
  default = []
}

variable "template_name" {
  type = string
}

variable "vm_count" {
  description = "How many virtual machines do you want to create? (Each VM will have 2 network cards)"
  type        = number
  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 50
    error_message = "VM count must be between 1 and 50."
  }
}

variable "name_prefix" {
  description = "What should be the prefix for your VM names? (e.g., 'web-server' creates web-server-1, web-server-2, etc.)"
  type        = string
  default     = "vm"
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

variable "use_dhcp" {
  description = "Use DHCP for IP assignment (when using single network)"
  type        = bool
  default     = true
}

variable "ipv4_network_prefix" {
  description = "IPv4 network prefix for static IPs (e.g., '192.168.1')"
  type        = string
  default     = "192.168.1"
}

variable "ipv4_address_start" {
  description = "Starting IPv4 address (last octet)"
  type        = number
  default     = 10
}

variable "ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
  default     = "192.168.1.1"
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

variable "esxi_host_name" {
  description = "ESXi hostname or IP to deploy VM directly (bypasses HA/DRS issues)"
  type        = string
  default     = null
}
