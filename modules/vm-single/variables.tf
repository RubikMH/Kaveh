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

variable "vm_name" {
  description = "VM name"
  type        = string
}

variable "vm_folder" {
  description = "VM folder path"
  type        = string
  default     = ""
}

variable "num_cpus" {
  description = "Number of CPUs"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 40
}

variable "thin_provisioned" {
  description = "Use thin provisioning"
  type        = bool
  default     = true
}

variable "ipv4_address" {
  description = "IPv4 address"
  type        = string
}

variable "ipv4_netmask" {
  description = "IPv4 netmask"
  type        = number
  default     = 24
}

variable "ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
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
  default     = "Managed by Terraform"
}
