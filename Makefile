.PHONY: help init validate format plan apply destroy clean console docs lint test

# Default target
.DEFAULT_GOAL := help

# Colors for terminal output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m

help: ## Show this help message
	@echo "$(BLUE)Kaveh - vSphere Terraform Automation$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-18s$(NC) %s\n", $$1, $$2}'

init: ## Initialize Terraform working directory
	@echo "$(BLUE)Initializing Terraform...$(NC)"
	@terraform init
	@echo "$(GREEN)✓ Terraform initialized$(NC)"

validate: init ## Validate Terraform configuration
	@echo "$(BLUE)Validating configuration...$(NC)"
	@terraform validate
	@echo "$(GREEN)✓ Configuration is valid$(NC)"

format: ## Format Terraform files
	@echo "$(BLUE)Formatting Terraform files...$(NC)"
	@terraform fmt -recursive
	@echo "$(GREEN)✓ Files formatted$(NC)"

format-check: ## Check Terraform formatting
	@terraform fmt -check -recursive

plan: init ## Generate execution plan
	@echo "$(BLUE)Generating plan...$(NC)"
	@terraform plan -out=tfplan
	@echo "$(GREEN)✓ Plan saved to tfplan$(NC)"

plan-destroy: init ## Generate destruction plan
	@echo "$(BLUE)Generating destruction plan...$(NC)"
	@terraform plan -destroy -out=tfplan-destroy

apply: ## Apply the saved plan
	@echo "$(YELLOW)Applying changes...$(NC)"
	@terraform apply tfplan
	@rm -f tfplan
	@echo "$(GREEN)✓ Applied successfully$(NC)"

apply-auto: init ## Apply changes without confirmation (USE WITH CAUTION)
	@echo "$(RED)Auto-applying changes...$(NC)"
	@terraform apply -auto-approve

destroy: ## Destroy infrastructure (requires confirmation)
	@echo "$(RED)Destroying infrastructure...$(NC)"
	@terraform destroy

destroy-auto: ## Destroy without confirmation (DANGEROUS)
	@echo "$(RED)Auto-destroying infrastructure...$(NC)"
	@terraform destroy -auto-approve

clean: ## Clean up Terraform files
	@echo "$(BLUE)Cleaning up...$(NC)"
	@rm -rf .terraform
	@rm -f .terraform.lock.hcl
	@rm -f tfplan tfplan-destroy
	@rm -f terraform.tfstate terraform.tfstate.backup
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

console: init ## Open Terraform console
	@terraform console

output: ## Show Terraform outputs
	@terraform output

refresh: ## Refresh Terraform state
	@terraform refresh

show: ## Show current state or plan
	@terraform show

state-list: ## List resources in state
	@terraform state list

lint: ## Run TFLint
	@echo "$(BLUE)Running TFLint...$(NC)"
	@tflint --init
	@tflint --recursive
	@echo "$(GREEN)✓ Linting complete$(NC)"

docs: ## Generate documentation with terraform-docs
	@echo "$(BLUE)Generating docs...$(NC)"
	@terraform-docs markdown table --output-file README.md --output-mode inject .
	@echo "$(GREEN)✓ Documentation updated$(NC)"

test: validate format-check lint ## Run all checks
	@echo "$(GREEN)✓ All tests passed$(NC)"

upgrade: ## Upgrade provider versions
	@terraform init -upgrade

graph: ## Generate dependency graph (requires graphviz)
	@terraform graph | dot -Tpng > graph.png
	@echo "$(GREEN)✓ Graph saved to graph.png$(NC)"

check-tools: ## Verify required tools are installed
	@echo "$(BLUE)Checking tools...$(NC)"
	@command -v terraform >/dev/null 2>&1 && echo "$(GREEN)✓ terraform$(NC)" || echo "$(RED)✗ terraform not found$(NC)"
	@command -v tflint >/dev/null 2>&1 && echo "$(GREEN)✓ tflint$(NC)" || echo "$(YELLOW)⚠ tflint not found$(NC)"
	@command -v terraform-docs >/dev/null 2>&1 && echo "$(GREEN)✓ terraform-docs$(NC)" || echo "$(YELLOW)⚠ terraform-docs not found$(NC)"
