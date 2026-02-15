# Interactive VM Deployment Demo

This document shows exactly what you'll see when running the interactive deployment.

## 🚀 Running the Interactive Deployment

### Method 1: Using the Deploy Script
```bash
cd /Users/rubik/workspace/projects/kaveh/examples/basic-cluster
./deploy.sh
```

**Output:**
```
==========================================
  vSphere VM Cluster Deployment Tool     
==========================================

🔐 Please enter your vSphere password:
[password hidden]

📋 Configuration Summary:
   • Each VM will have 2 network cards (net001 & net002)
   • Network configuration: DHCP enabled
   • Resources per VM: 2 CPUs, 4GB RAM, 40GB disk

🔄 Initializing Terraform...
✅ Validating configuration...
🚀 Ready to deploy VMs!

Notes:
   • Terraform will prompt you for the number of VMs to create
   • Terraform will prompt you for a VM name prefix (optional)
   • Each VM will automatically get 2 network interfaces

📊 Planning deployment...
```

### Method 2: Direct Terraform
```bash
export TF_VAR_vsphere_password="your_password"
terraform apply
```

## 📝 Interactive Prompts

### Prompt 1: Number of VMs
```
var.vm_count
  How many virtual machines do you want to create? (Each VM will have 2 network cards)

  Enter a value: 3
```

### Prompt 2: VM Name Prefix
```
var.name_prefix
  What should be the prefix for your VM names? (e.g., 'web-server' creates web-server-1, web-server-2, etc.)

  Enter a value: web-app
```

## 📊 Terraform Plan Output

```
Terraform will perform the following actions:

  # module.vm_cluster.vsphere_virtual_machine.vms[0] will be created
  + resource "vsphere_virtual_machine" "vms" {
      + name             = "web-app-1"
      + num_cpus         = 2
      + memory           = 4096
      + network_interface {
          + network_id   = "network-123"  # net001
          + adapter_type = "vmxnet3"
        }
      + network_interface {
          + network_id   = "network-456"  # net002  
          + adapter_type = "vmxnet3"
        }
    }

  # module.vm_cluster.vsphere_virtual_machine.vms[1] will be created
  + resource "vsphere_virtual_machine" "vms" {
      + name             = "web-app-2"
      + num_cpus         = 2
      + memory           = 4096
      + network_interface {
          + network_id   = "network-123"  # net001
          + adapter_type = "vmxnet3"
        }
      + network_interface {
          + network_id   = "network-456"  # net002
          + adapter_type = "vmxnet3"
        }
    }

  # module.vm_cluster.vsphere_virtual_machine.vms[2] will be created
  + resource "vsphere_virtual_machine" "vms" {
      + name             = "web-app-3"
      + num_cpus         = 2
      + memory           = 4096
      + network_interface {
          + network_id   = "network-123"  # net001
          + adapter_type = "vmxnet3"
        }
      + network_interface {
          + network_id   = "network-456"  # net002
          + adapter_type = "vmxnet3"
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```

## ✅ Final Output After Creation

```
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

cluster_info = {
  "name_prefix" = "web-app"
  "network_count" = 2
  "networks" = [
    "net001",
    "net002",
  ]
  "resource_per_vm" = {
    "cpus" = 2
    "disk" = "40GB"
    "memory" = "4096MB"
  }
  "vm_count" = 3
}

vm_names = [
  "web-app-1",
  "web-app-2",
  "web-app-3",
]

vm_ip_addresses = [
  "192.168.1.101",
  "192.168.1.102",
  "192.168.1.103",
]
```

## 📋 What Happens Next

1. **3 VMs Created**: `web-app-1`, `web-app-2`, `web-app-3`
2. **6 Network Cards Total**: Each VM gets 2 network interfaces
3. **DHCP Assignment**: All network cards get IP addresses automatically
4. **Ready to Use**: VMs are powered on and ready for configuration

## 🔄 Scaling Example

To add more VMs, just run `terraform apply` again:

```
terraform apply

var.vm_count
  How many virtual machines do you want to create? (Each VM will have 2 network cards)

  Enter a value: 5    # Changed from 3 to 5

var.name_prefix
  What should be the prefix for your VM names?

  Enter a value: web-app    # Same as before
```

**Result**: Terraform will add `web-app-4` and `web-app-5` (each with 2 network cards)