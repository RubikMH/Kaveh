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
  type = string
}

variable "template_name" {
  type = string
}

variable "esxi_host_name" {
  description = "ESXi hostname or IP to deploy VM directly (bypasses HA/DRS issues)"
  type        = string
  default     = null
}
