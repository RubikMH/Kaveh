# Interactive VM Cluster Deployment

This example provides an **interactive deployment** that asks you how many virtual machines you want to create. **Every VM will automatically have 2 network interfaces**.

## 🎯 Quick Interactive Deployment

### Option 1: Use the Deployment Script (Recommended)
```bash
cd /Users/rubik/workspace/projects/kaveh/examples/basic-cluster
./deploy.sh
```

The script will:
- ✅ Prompt for your vSphere password
- ✅ Ask how many VMs you want to create  
- ✅ Ask for a VM name prefix
- ✅ Automatically configure 2 network cards per VM
- ✅ Deploy everything with validation

### Option 2: Manual Terraform Commands
```bash
cd /Users/rubik/workspace/projects/kaveh/examples/basic-cluster
export TF_VAR_vsphere_password="your_password"
terraform init
terraform apply
```

Terraform will interactively prompt you for:
- **VM Count**: `How many virtual machines do you want to create?`
- **Name Prefix**: `What should be the prefix for your VM names?`

## 🔧 What You'll Be Asked

### 1. Number of VMs
```
var.vm_count
  How many virtual machines do you want to create? (Each VM will have 2 network cards)

  Enter a value: 3
```

### 2. VM Name Prefix (Optional)
```
var.name_prefix
  What should be the prefix for your VM names? (e.g., 'web-server' creates web-server-1, web-server-2, etc.)

  Enter a value: web-server
```

## 📊 What Gets Created

**Example: If you choose 3 VMs with prefix "web-server"**
- **3 Virtual Machines**: `web-server-1`, `web-server-2`, `web-server-3`
- **6 Network Cards Total**: Each VM gets 2 network interfaces
- **Resources**: Based on configuration (default: 2 CPUs, 4GB RAM, 40GB disk per VM)

## 🌐 Network Configuration (Fixed)

**Every VM automatically gets these 2 network cards:**
```hcl
Network Card 1: net001 (Management) - DHCP
Network Card 2: net002 (Data) - DHCP
```

## ⚙️ Customization Options

## ⚙️ Customization Options

### Modify Resources Per VM
Edit `terraform.tfvars`:
```hcl
# Resource allocation per VM
num_cpus  = 4      # 4 CPUs per VM
memory    = 8192   # 8GB RAM per VM  
disk_size = 100    # 100GB disk per VM
```

### Change Network Names
Edit `terraform.tfvars`:
```hcl
networks = [
  {
    name         = "Management"        # First network interface
    ipv4_address = null               # DHCP
    ipv4_netmask = 24
  },
  {
    name         = "Storage"           # Second network interface
    ipv4_address = null               # DHCP
    ipv4_netmask = 24
  }
]
```

### Use Static IPs Instead of DHCP
Edit `terraform.tfvars`:
```hcl
use_dhcp = false
ipv4_network_prefix = "192.168.1"
ipv4_address_start  = 10    # VMs get: .10, .11, .12, etc.
ipv4_gateway = "192.168.1.1"
```

## 📈 Example Scenarios

### Scenario 1: Small Development Environment
- **Input**: 2 VMs, prefix "dev"
- **Result**: `dev-1`, `dev-2` (each with 2 network cards)
- **Total**: 4 CPUs, 8GB RAM, 80GB storage

### Scenario 2: Web Server Farm  
- **Input**: 5 VMs, prefix "web"
- **Result**: `web-1`, `web-2`, `web-3`, `web-4`, `web-5`
- **Total**: 10 CPUs, 20GB RAM, 200GB storage

### Scenario 3: Database Cluster
- **Input**: 3 VMs, prefix "db"
- **Result**: `db-1`, `db-2`, `db-3`
- **Total**: 6 CPUs, 12GB RAM, 120GB storage

## 📊 Expected Output

After deployment, you'll see detailed information about all created VMs:

```bash
cluster_info = {
  "name_prefix" = "web-server"
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
  "web-server-1",
  "web-server-2",
  "web-server-3",
]

vm_ip_addresses = [
  "192.168.1.100",
  "192.168.1.101", 
  "192.168.1.102",
]
```

## 🔧 Troubleshooting

### Validation Errors
The configuration includes validation to ensure:
- VM count is between 1 and 50
- All required variables are provided

### Network Issues
- Ensure network names (`net001`, `net002`) exist in your vSphere environment
- Check DHCP availability on both networks
- Verify network permissions

## 🧹 Clean Up

To destroy all VMs:
```bash
terraform destroy
```

Terraform will show you exactly what will be destroyed before proceeding.

## 🔄 Scaling

To change the number of VMs after initial deployment:
1. Run `terraform apply` again
2. Enter a different number when prompted
3. Terraform will add or remove VMs as needed

**Note**: Terraform will preserve existing VMs and only modify what's necessary.