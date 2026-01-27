terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.6"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

# K8s Master Nodes
module "k8s_masters" {
  source = "../../modules/vm-cluster"

  datacenter    = var.datacenter
  datastore     = var.datastore
  cluster       = var.cluster
  network       = var.network
  template_name = var.template_name

  name_prefix          = "k8s-master"
  vm_count             = 3
  vm_folder            = "kubernetes/masters"
  
  num_cpus             = 4
  memory               = 8192
  disk_size            = 100
  
  ipv4_network_prefix  = "192.168.1"
  ipv4_address_start   = 10
  ipv4_gateway         = "192.168.1.1"
  dns_servers          = ["192.168.1.1", "8.8.8.8"]
  domain               = "k8s.local"
  
  annotation           = "Kubernetes Master Node"
}

# K8s Worker Nodes
module "k8s_workers" {
  source = "../../modules/vm-cluster"

  datacenter    = var.datacenter
  datastore     = var.datastore
  cluster       = var.cluster
  network       = var.network
  template_name = var.template_name

  name_prefix          = "k8s-worker"
  vm_count             = 5
  vm_folder            = "kubernetes/workers"
  
  num_cpus             = 8
  memory               = 16384
  disk_size            = 200
  
  ipv4_network_prefix  = "192.168.1"
  ipv4_address_start   = 20
  ipv4_gateway         = "192.168.1.1"
  dns_servers          = ["192.168.1.1", "8.8.8.8"]
  domain               = "k8s.local"
  
  annotation           = "Kubernetes Worker Node"
}

output "master_ips" {
  value = module.k8s_masters.vm_ip_addresses
}

output "worker_ips" {
  value = module.k8s_workers.vm_ip_addresses
}
