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

variable "host_name" {
  description = "Specific ESXi host name to deploy VM to (optional - bypasses HA/DRS)"
  type        = string
  default     = null
}

variable "network" {
  description = "Network name (for backward compatibility - use networks for multiple interfaces)"
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
  description = "IPv4 address (optional - if not provided, no customization will be applied)"
  type        = string
  default     = null
}

variable "ipv4_netmask" {
  description = "IPv4 netmask"
  type        = number
  default     = 24
}

variable "ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
  default     = null
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

variable "use_cloud_init" {
  description = "Use cloud-init instead of customization spec"
  type        = bool
  default     = false
}

variable "cloud_init_metadata" {
  description = "Cloud-init metadata (base64 encoded)"
  type        = string
  default     = ""
}

variable "cloud_init_userdata" {
  description = "Cloud-init userdata (base64 encoded)"
  type        = string
  default     = ""
}

variable "hardware_version" {
  description = "VM hardware version (numeric: 15=ESXi 6.7+, 17=ESXi 7.0+, 19=ESXi 7.0U2+, 20=ESXi 8.0+). If null, uses template hardware version"
  type        = number
  default     = null
}

variable "firmware" {
  description = "VM firmware type (bios or efi). If null, uses template firmware"
  type        = string
  default     = null
}

variable "wait_for_guest_net_timeout" {
  description = "Timeout for waiting for guest network (seconds)"
  type        = number
  default     = 5
}

variable "wait_for_guest_ip_timeout" {
  description = "Timeout for waiting for guest IP address (seconds)"
  type        = number
  default     = 5
}
