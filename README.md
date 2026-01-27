# Kaveh - VMware vSphere Terraform Automation

<div align="center">

![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![vSphere](https://img.shields.io/badge/vSphere-607078?style=for-the-badge&logo=vmware&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Forge Virtual Machines with Code**

Named after Kaveh the Blacksmith (کاوه آهنگر), the legendary Persian craftsman who forged tools and led a revolution against tyranny.

</div>

---

## 📋 Overview

Kaveh is a comprehensive Terraform configuration for automating VMware vSphere virtual machine provisioning. Built with production-ready practices and infrastructure-as-code principles.

### Features

- ✨ **Production-Ready**: Secure variable management and state handling
- 🔄 **Flexible Deployment**: Support for single or multiple VM deployments
- 🛠️ **Customizable**: Template-based cloning with network customization
- 📦 **Cloud-Init Support**: Modern initialization for Linux VMs
- 🔐 **Secure**: Sensitive data handling with Terraform best practices
- 🎯 **GitOps Ready**: Designed for CI/CD integration

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

---

## 📁 Project Structure

```
kaveh/
├── provider.tf          # Terraform and provider configuration
├── variables.tf         # Variable definitions
├── data.tf             # Data sources for vSphere objects
├── main.tf             # VM resource definitions
├── outputs.tf          # Output values
├── terraform.tfvars.example  # Example configuration
├── modules/            # Reusable Terraform modules
│   ├── vm-single/     # Single VM module
│   └── vm-cluster/    # Multiple VM cluster module
├── cloud-init/        # Cloud-init configuration files
│   ├── metadata.yaml
│   └── userdata.yaml
└── examples/          # Usage examples
    ├── basic/
    ├── kubernetes-nodes/
    └── windows-vm/
```

---

## ⚙️ Configuration

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

---

## 🔧 Advanced Features

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

### GitLab CI Example

```yaml
# .gitlab-ci.yml
stages:
  - validate
  - plan
  - apply

variables:
  TF_ROOT: ${CI_PROJECT_DIR}
  TF_STATE_NAME: ${CI_COMMIT_REF_SLUG}

before_script:
  - cd ${TF_ROOT}
  - terraform init

validate:
  stage: validate
  script:
    - terraform fmt -check
    - terraform validate

plan:
  stage: plan
  script:
    - terraform plan -out=plan.tfplan
  artifacts:
    paths:
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

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

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
