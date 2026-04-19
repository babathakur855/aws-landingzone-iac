# =============================================================================
# Module: aft (Account Factory for Terraform)
# Purpose: Deploys AWS Control Tower Account Factory for Terraform.
#
# This module wraps the official AWS AFT module and provides the landing zone
# integration. AFT will:
#   - Vend new AWS accounts through a GitOps pipeline
#   - Apply global and per-account customizations
#   - Manage account-level Terraform state
#
# Reference: https://github.com/aws-ia/terraform-aws-control_tower_account_factory
# =============================================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }
}

# -----------------------------------------------------------------------------
# AFT Module — Official AWS Implementation Architecture
# -----------------------------------------------------------------------------
module "aft" {
  source = "github.com/aws-ia/terraform-aws-control_tower_account_factory?ref=1.12.0"

  # Control Tower Account IDs
  ct_management_account_id    = var.ct_management_account_id
  log_archive_account_id      = var.log_archive_account_id
  audit_account_id            = var.audit_account_id
  aft_management_account_id   = var.aft_management_account_id
  ct_home_region              = var.ct_home_region

  # Feature Flags
  aft_feature_cloudtrail_data_events = var.aft_feature_cloudtrail_data_events
  aft_feature_enterprise_support     = var.aft_feature_enterprise_support
  aft_feature_delete_default_vpcs_enabled = var.aft_feature_delete_default_vpcs

  # Terraform Configuration
  terraform_version      = var.terraform_version
  terraform_distribution = var.terraform_distribution

  # AFT Networking
  aft_vpc_cidr                     = var.aft_vpc_cidr
  aft_vpc_private_subnet_01_cidr   = cidrsubnet(var.aft_vpc_cidr, 2, 0)
  aft_vpc_private_subnet_02_cidr   = cidrsubnet(var.aft_vpc_cidr, 2, 1)
  aft_vpc_public_subnet_01_cidr    = cidrsubnet(var.aft_vpc_cidr, 2, 2)
  aft_vpc_public_subnet_02_cidr    = cidrsubnet(var.aft_vpc_cidr, 2, 3)

  # VCS Provider
  vcs_provider = var.vcs_provider

  # Repository Configuration
  account_request_repo_name    = var.account_request_repo_name
  account_request_repo_branch  = var.account_request_repo_branch

  account_customizations_repo_name    = var.account_customizations_repo_name
  account_customizations_repo_branch  = var.account_customizations_repo_branch

  account_provisioning_customizations_repo_name    = var.account_provisioning_customizations_repo_name
  account_provisioning_customizations_repo_branch  = var.account_provisioning_customizations_repo_branch

  global_customizations_repo_name    = var.global_customizations_repo_name
  global_customizations_repo_branch  = var.global_customizations_repo_branch
}

# -----------------------------------------------------------------------------
# SSM Parameters — Store AFT configuration for downstream consumers
# -----------------------------------------------------------------------------
resource "aws_ssm_parameter" "aft_management_account_id" {
  name        = "/landingzone/aft/management-account-id"
  description = "AFT Management account ID."
  type        = "String"
  value       = var.aft_management_account_id

  tags = var.tags
}

resource "aws_ssm_parameter" "aft_vcs_provider" {
  name        = "/landingzone/aft/vcs-provider"
  description = "AFT VCS provider."
  type        = "String"
  value       = var.vcs_provider

  tags = var.tags
}

resource "aws_ssm_parameter" "aft_terraform_version" {
  name        = "/landingzone/aft/terraform-version"
  description = "Terraform version used by AFT pipelines."
  type        = "String"
  value       = var.terraform_version

  tags = var.tags
}