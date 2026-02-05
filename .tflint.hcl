# TFLint Configuration for Kaveh vSphere Automation
# https://github.com/terraform-linters/tflint

# Main configuration
config {
  # Enable module inspection for deeper analysis
  call_module_type = "local"

  # Force to return an error when issues are found
  force = false

  # Disable rules by default and enable specific ones
  disabled_by_default = false
}

# Enable the Terraform plugin for general best practices
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# ============================================
# Terraform Language Rules
# ============================================

# Require description for all variables
rule "terraform_documented_variables" {
  enabled = true
}

# Require description for all outputs
rule "terraform_documented_outputs" {
  enabled = true
}

# Disallow deprecated syntax (index functions, etc.)
rule "terraform_deprecated_index" {
  enabled = true
}

# Disallow deprecated interpolation syntax
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Disallow empty list assignment to attributes
rule "terraform_empty_list_equality" {
  enabled = true
}

# Enforce naming conventions
rule "terraform_naming_convention" {
  enabled = true

  # Variable naming: snake_case
  variable {
    format = "snake_case"
  }

  # Output naming: snake_case
  output {
    format = "snake_case"
  }

  # Resource naming: snake_case
  resource {
    format = "snake_case"
  }

  # Data source naming: snake_case
  data {
    format = "snake_case"
  }

  # Local value naming: snake_case
  locals {
    format = "snake_case"
  }

  # Module naming: snake_case
  module {
    format = "snake_case"
  }
}

# Require terraform and provider version constraints
rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

# Prefer using separate files for different resource types
rule "terraform_standard_module_structure" {
  enabled = true
}

# Disallow variables, outputs, and locals without type declaration
rule "terraform_typed_variables" {
  enabled = true
}

# Warn about unused declarations
rule "terraform_unused_declarations" {
  enabled = true
}

# Warn about unused required providers
rule "terraform_unused_required_providers" {
  enabled = true
}

# Suggest using workspace-aware expressions
rule "terraform_workspace_remote" {
  enabled = true
}

# ============================================
# Custom Rules for vSphere Best Practices
# ============================================

# Ensure comments are meaningful (no empty comments)
rule "terraform_comment_syntax" {
  enabled = true
}

# Suggest using count or for_each for resources
rule "terraform_module_pinned_source" {
  enabled = true

  # Set style to "flexible" to allow ~ version constraints
  style = "flexible"
}
