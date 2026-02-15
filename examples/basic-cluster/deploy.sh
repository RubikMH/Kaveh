#!/bin/bash

# Interactive VM Deployment Script for vSphere
# This script will prompt you for the number of VMs and deploy them with 2 network cards each

echo "=========================================="
echo "  vSphere VM Cluster Deployment Tool     "
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "main.tf" ] || [ ! -f "variables.tf" ]; then
    echo "❌ Error: Please run this script from the basic-cluster directory"
    echo "   cd /Users/rubik/workspace/projects/kaveh/examples/basic-cluster"
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Error: Terraform is not installed or not in PATH"
    exit 1
fi

# Set vSphere password if not already set
if [ -z "$TF_VAR_vsphere_password" ]; then
    echo "🔐 Please enter your vSphere password:"
    read -s TF_VAR_vsphere_password
    export TF_VAR_vsphere_password
    echo ""
fi

echo "📋 Configuration Summary:"
echo "   • Each VM will have 2 network cards (net001 & net002)"
echo "   • Network configuration: DHCP enabled"
echo "   • Resources per VM: 2 CPUs, 4GB RAM, 40GB disk"
echo ""

# Initialize Terraform if needed
echo "🔄 Initializing Terraform..."
terraform init -upgrade > /dev/null 2>&1

# Validate configuration
echo "✅ Validating configuration..."
if ! terraform validate > /dev/null 2>&1; then
    echo "❌ Configuration validation failed!"
    terraform validate
    exit 1
fi

echo "🚀 Ready to deploy VMs!"
echo ""
echo "Notes:"
echo "   • Terraform will prompt you for the number of VMs to create"
echo "   • Terraform will prompt you for a VM name prefix (optional)"
echo "   • Each VM will automatically get 2 network interfaces"
echo ""

# Run terraform plan and apply
echo "📊 Planning deployment..."
terraform plan

if [ $? -eq 0 ]; then
    echo ""
    echo "🎯 Ready to create your VMs!"
    echo "   Type 'yes' when prompted to proceed with deployment"
    echo ""
    terraform apply
else
    echo "❌ Planning failed! Please check your configuration."
    exit 1
fi

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 To view your VMs:"
echo "   terraform output"
echo ""
echo "🧹 To destroy all VMs:"
echo "   terraform destroy"