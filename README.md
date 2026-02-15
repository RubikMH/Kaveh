# Kaveh - VMware vSphere Terraform Automation

<div align="center">

![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![vSphere](https://img.shields.io/badge/vSphere-607078?style=for-the-badge&logo=vmware&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Forge Virtual Machines with Code**

Named after Kaveh the Blacksmith (کاوه آهنگر), the legendary Persian craftsman who forged tools and led a revolution against tyranny.

🎯 **NEW: Interactive VM Deployment with Dual Network Cards!**

</div>

---

## 📋 Overview

Kaveh is a comprehensive Terraform configuration for automating VMware vSphere virtual machine provisioning. Built with production-ready practices and infrastructure-as-code principles.

### Features

- ✨ **Interactive Deployment**: Prompts for VM count and naming preferences
- 🌐 **Dual Network Cards**: Every VM automatically gets 2 network interfaces
- 🔄 **Scalable**: Deploy 1-50 VMs with a single command  
- 🛠️ **Modular Design**: Reusable modules for different deployment scenarios
- 📦 **Cloud-Init Support**: Modern initialization for Linux VMs
- 🔐 **Secure**: Sensitive data handling with Terraform best practices
- 🎯 **GitOps Ready**: Designed for CI/CD integration
- ✅ **Input Validation**: Comprehensive variable validation to prevent misconfigurations
- 🧹 **Linting**: TFLint configuration for Terraform best practices
- 🛠️ **Makefile**: Simplified commands for common operations

---

## 🚀 Quick Start

### Prerequisites

- Terraform >= 1.0
- VMware vSphere 6.5+ / vCenter
- Valid vSphere credentials with VM provisioning permissions
- Prepared VM template in vSphere

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/RubikMH/kaveh.git
cd kaveh
```

2. **Copy and configure variables**
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your environment details
```

3. **Set sensitive credentials** (choose one method)

**Option A: Environment Variables (Recommended)**
```bash
export TF_VAR_vsphere_user="administrator@vsphere.local"
export TF_VAR_vsphere_password="your-secure-password"
```

**Option B: Terraform tfvars (Not recommended for production)**
```bash
# Add to terraform.tfvars (DO NOT COMMIT)
vsphere_user     = "administrator@vsphere.local"
vsphere_password = "your-secure-password"
```

4. **Initialize and deploy**
```bash
terraform init
terraform plan
terraform apply
```

Or use the **Makefile** for simplified operations:
```bash
make init      # Initialize Terraform
make plan      # Generate execution plan
make apply     # Apply the saved plan
```

---

## 🛠️ Makefile Commands

The project includes a Makefile for common operations:

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make init` | Initialize Terraform working directory |
| `make validate` | Validate Terraform configuration |
| `make format` | Format Terraform files to canonical format |
| `make format-check` | Check if files are properly formatted |
| `make plan` | Generate and save execution plan |
| `make plan-destroy` | Generate destruction plan |
| `make apply` | Apply the saved plan |
| `make apply-auto` | Apply without confirmation ⚠️ |
| `make destroy` | Destroy infrastructure (requires confirmation) |
| `make destroy-auto` | Destroy without confirmation ⚠️ |
| `make clean` | Clean up Terraform files |
| `make console` | Open Terraform console |
| `make output` | Show Terraform outputs |
| `make lint` | Run TFLint |
| `make docs` | Generate documentation with terraform-docs |
| `make test` | Run all checks (validate, format, lint) |
| `make check-tools` | Verify required tools are installed |
| `make upgrade` | Upgrade provider versions |
| `make graph` | Generate dependency graph |

---

## 📁 Project Structure

```
kaveh/
├── provider.tf          # Terraform and provider configuration
├── variables.tf         # Variable definitions with validation
├── data.tf             # Data sources for vSphere objects
├── main.tf             # VM resource definitions
├── outputs.tf          # Output values
├── locals.tf           # Computed values and data transformations
├── Makefile            # Common operations shortcuts
├── .tflint.hcl         # TFLint configuration
├── terraform.tfvars.example  # Example configuration
├── modules/            # Reusable Terraform modules
│   ├── vm-single/     # Single VM module (supports cluster or host deployment)
│   ├── vm-single-host/# Single VM module (dedicated host deployment)
│   └── vm-cluster/    # Multiple VM cluster module
├── cloud-init/        # Cloud-init configuration files
│   ├── metadata.yaml  # Cloud-init metadata configuration
│   └── userdata.yaml  # Cloud-init user data with packages and settings
└── examples/          # Usage examples
    ├── basic-cluster/ # Simple VM deployment using cluster
    ├── basic-host/    # Simple VM deployment using specific host
    ├── kubernetes-nodes/ # Kubernetes cluster deployment example
    ├── windows-vm-cluster/ # Windows Server VM on cluster
    └── windows-vm-host/    # Windows Server VM on specific host
```

---

## ⚙️ Configuration

### Variable Validation

Kaveh includes comprehensive input validation to prevent misconfigurations:

| Variable | Validation Rules |
|----------|------------------|
| `vsphere_user` | Cannot be empty |
| `vsphere_password` | Minimum 8 characters |
| `vsphere_server` | Valid FQDN or IP address format |
| `datacenter`, `datastore`, `cluster`, `network` | Cannot be empty |
| `vm_name` | Alphanumeric + hyphens, starts with letter, max 63 chars |
| `vm_num_cpus` | Between 1 and 128 |
| `vm_memory` | Between 512 MB and 6 TB, multiple of 4 |
| `vm_disk_size` | Between 1 GB and 62 TB |
| `vm_ipv4_address` | Valid IPv4 format or empty (for DHCP) |
| `vm_ipv4_netmask` | Between 1 and 32 bits |
| `vm_ipv4_gateway` | Valid IPv4 format or empty |
| `vm_dns_servers` | At least one DNS server required |
| `vm_domain` | Valid domain name format |

### Basic Configuration

Edit `terraform.tfvars`:

```hcl
# vSphere Connection
vsphere_server       = "vcenter.example.com"
allow_unverified_ssl = false  # Set to true for self-signed certs

# Infrastructure
datacenter = "Datacenter1"
datastore  = "datastore1"
cluster    = "Cluster1"
network    = "VM Network"
template   = "ubuntu-22.04-template"
```

### VM Specifications

In `main.tf`, customize your VM:

```hcl
resource "vsphere_virtual_machine" "vm" {
  name   = "my-vm"
  
  # Resources
  num_cpus = 4
  memory   = 8192  # MB
  
  # Disk
  disk {
    label = "disk0"
    size  = 50      # GB
  }
  
  # Network
  network_interface {
    network_id = data.vsphere_network.network.id
  }
}
```

---

## 📖 Usage Examples 

Kaveh provides several practical examples to help you get started:

### Example Overview

| Example | Description | Use Case |
|---------|-------------|----------|
| **[basic-cluster/](examples/basic-cluster/)** | Simple VM deployment using cluster resource pool | General-purpose VM with HA/DRS support |
| **[basic-host/](examples/basic-host/)** | Simple VM deployment targeting specific ESXi host | Direct host deployment, bypasses HA/DRS |
| **[kubernetes-nodes/](examples/kubernetes-nodes/)** | Multiple VM setup for Kubernetes cluster | Container orchestration infrastructure |
| **[windows-vm-cluster/](examples/windows-vm-cluster/)** | Windows Server VM on cluster | Windows workloads with cluster benefits |
| **[windows-vm-host/](examples/windows-vm-host/)** | Windows Server VM on specific host | Windows workloads on dedicated host |

### Basic Cluster Deployment

```bash
cd examples/basic-cluster
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your environment details
terraform init
terraform plan
terraform apply
```

### Cloud-Init Integration

All Linux examples support cloud-init for automated configuration:

```yaml
# cloud-init/userdata.yaml
#cloud-config
hostname: kaveh-vm
users:
  - name: sysadmin
    groups: sudo, docker
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']

packages:
  - docker.io
  - kubectl
  - git
  - vim

runcmd:
  - systemctl enable docker
  - systemctl start docker
  - usermod -aG docker sysadmin
```

### Single VM Deployment

```hcl
resource "vsphere_virtual_machine" "web_server" {
  name             = "web-server-01"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = "ubuntu64Guest"

  # ... rest of configuration
}
```

### Multiple VMs (Kubernetes Nodes)

```hcl
resource "vsphere_virtual_machine" "k8s_workers" {
  count = 3

  name             = "k8s-worker-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 4
  memory   = 8192
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 100
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "k8s-worker-${count.index + 1}"
        domain    = "cluster.local"
      }

      network_interface {
        ipv4_address = "192.168.1.${20 + count.index}"
        ipv4_netmask = 24
      }

      ipv4_gateway    = "192.168.1.1"
      dns_server_list = ["192.168.1.1", "8.8.8.8"]
    }
  }
}
```

### With Cloud-Init

```hcl
resource "vsphere_virtual_machine" "cloud_init_vm" {
  # ... basic configuration ...

  extra_config = {
    "guestinfo.metadata"          = base64encode(file("${path.module}/cloud-init/metadata.yaml"))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(file("${path.module}/cloud-init/userdata.yaml"))
    "guestinfo.userdata.encoding" = "base64"
  }
}
```

**cloud-init/userdata.yaml**:
```yaml
#cloud-config
hostname: cloud-vm
fqdn: cloud-vm.example.com

users:
  - name: admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ssh-rsa AAAAB3... your-key

packages:
  - docker.io
  - kubectl

runcmd:
  - systemctl enable docker
  - systemctl start docker
  - echo "VM provisioned successfully" > /var/log/cloud-init-complete
```

### Module Structure

Kaveh offers modular architecture with three main modules:

#### vm-single Module
- **Purpose**: Deploy a single VM with flexible placement options
- **Features**: Supports both cluster and specific host deployment
- **Cloud-Init**: Optional cloud-init support for automated configuration
- **Customization**: Conditional network customization based on deployment type

#### vm-single-host Module  
- **Purpose**: Deploy a VM directly to a specific ESXi host
- **Use Case**: Bypasses HA/DRS for direct host control
- **Features**: Dedicated host resource pool, cloud-init support

#### vm-cluster Module
- **Purpose**: Deploy multiple VMs as a coordinated cluster
- **Features**: Bulk deployment, consistent configuration, naming schemes

---

## 🔧 Advanced Features

### Local Values

The `locals.tf` file provides computed values for better code organization:

```hcl
# Available local values
local.vm_name_sanitized    # Sanitized VM name (lowercase, no special chars)
local.vm_fqdn              # Full hostname with domain
local.resource_pool_id     # Computed resource pool ID
local.use_static_ip        # Boolean: true if static IP configured
local.network_config       # Network configuration map
local.effective_disk_size  # Disk size (at least as large as template)
local.cloud_init_config    # Pre-built cloud-init config map
local.vm_annotation        # Final annotation with fallback to default
local.common_tags          # Standard tags (managed_by, project, environment)
local.all_tags             # Merged common + user-provided tags
```

### TFLint Integration

Run TFLint to catch issues early:

```bash
make lint
# or
tflint --init && tflint --recursive
```

The `.tflint.hcl` configuration enforces:
- Terraform naming conventions (snake_case)
- Required descriptions for variables and outputs
- Deprecated syntax detection
- Unused declarations warnings
- Module source pinning
- Standard module structure

### Remote State Storage (MinIO/S3)

Configure backend in `provider.tf`:

```hcl
terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "vsphere/kaveh.tfstate"
    region                      = "us-east-1"
    endpoint                    = "https://minio.example.com"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

### Workspaces (Multi-Environment)

```bash
# Create environments
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch between environments
terraform workspace select dev
terraform apply -var-file="env/dev.tfvars"
```

### Modules

Use the included modules for reusable configurations:

```hcl
module "web_servers" {
  source = "./modules/vm-cluster"

  count        = 3
  name_prefix  = "web"
  vm_template  = "ubuntu-template"
  num_cpus     = 2
  memory       = 4096
  disk_size    = 30
}
```

---

## 🔐 Security Best Practices

1. **Never commit sensitive data**
   - Use `.gitignore` for `terraform.tfvars`, `*.tfstate`, and `*.tfstate.backup`
   - Store credentials in environment variables or secrets manager

2. **Use remote state with encryption**
   - Store state in S3/MinIO with versioning enabled
   - Enable state locking with DynamoDB or similar

3. **Implement least privilege**
   - Create dedicated vSphere service account
   - Grant only necessary permissions for VM provisioning

4. **Enable SSL verification**
   - Use proper SSL certificates in production
   - Set `allow_unverified_ssl = false`

---

## 🎯 CI/CD Integration

### GitHub Actions Example

```yaml
# .github/workflows/terraform.yml
name: 'Terraform Infrastructure'

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  terraform:
    runs-on: ubuntu-latest
    env:
      TF_VAR_vsphere_server: ${{ secrets.VSPHERE_SERVER }}
      TF_VAR_vsphere_user: ${{ secrets.VSPHERE_USER }}
      TF_VAR_vsphere_password: ${{ secrets.VSPHERE_PASSWORD }}

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: ~1.0

    - name: Terraform Init
      run: terraform init

    - name: Terraform Format Check
      run: terraform fmt -check

    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan
      - ${TF_ROOT}/plan.tfplan

apply:
  stage: apply
  script:
    - terraform apply -auto-approve plan.tfplan
  when: manual
  only:
    - main
```

---

## 📊 Outputs

After successful deployment, Kaveh provides useful outputs:

```hcl
output "vm_ip_addresses" {
  description = "IP addresses of created VMs"
  value       = vsphere_virtual_machine.vm[*].default_ip_address
}

output "vm_names" {
  description = "Names of created VMs"
  value       = vsphere_virtual_machine.vm[*].name
}

output "vm_uuids" {
  description = "UUIDs of created VMs"
  value       = vsphere_virtual_machine.vm[*].uuid
}
```

View outputs:
```bash
terraform output
terraform output -json
```

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: Template not found
```bash
# List available templates
govc find / -type VirtualMachine -name "*template*"
```

**Issue**: Network customization fails
- Ensure VMware Tools is installed in the template
- Verify network settings in customize block
- Check DHCP availability if using dynamic IP

**Issue**: Authentication fails
```bash
# Test vSphere connectivity
govc about -u "user:pass@vcenter.example.com"
```

### Debug Mode

Enable Terraform debug logging:
```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log
terraform apply
```

---

## 📚 Additional Resources

- [Terraform vSphere Provider Documentation](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs)
- [VMware vSphere API Reference](https://developer.vmware.com/apis/vsphere-automation/latest/)
- [Cloud-Init Documentation](https://cloudinit.readthedocs.io/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [terraform-docs](https://terraform-docs.io/)

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Run tests before committing (`make test`)
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

### Development Setup

```bash
# Check required tools
make check-tools

# Install recommended tools (macOS)
brew install terraform tflint terraform-docs

# Run all checks before committing
make test
```

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Rubik**
- GitHub: [@RubikMH](https://github.com/RubikMH)
- Website: [rubikmh.io](https://rubikmh.io)

---

## 🙏 Acknowledgments

- Named after Kaveh the Blacksmith, symbol of resistance and craftsmanship in Persian mythology
- Built for modern infrastructure automation
- Part of the Persian-themed infrastructure suite (Simorgh, Anahita, Rostam, Gaokerena, Didban)

---

<div align="center">

**⚒️ Forged with care by Kaveh ⚒️**

If this project helps you, please consider giving it a ⭐️

</div>
