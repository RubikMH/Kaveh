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

variable "esxi_host_name" {
  description = "ESXi hostname or IP to deploy VM directly (bypasses HA/DRS issues)"
  type        = string
  default     = null
}
