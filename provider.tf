terraform {
  required_version = ">= 1.0"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.6"
    }
  }

  # Uncomment and configure for remote state storage
  # backend "s3" {
  #   bucket                      = "terraform-state"
  #   key                         = "vsphere/kaveh.tfstate"
  #   region                      = "us-east-1"
  #   endpoint                    = "https://anahita.rubikmh.io"
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  #   force_path_style            = true
  #   
  #   # Use environment variables for credentials:
  #   # AWS_ACCESS_KEY_ID
  #   # AWS_SECRET_ACCESS_KEY
  # }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.allow_unverified_ssl

  # Optional: Set API timeout
  api_timeout = 10
}
