# =============================================================================
# AWS Landing Zone — Root Composition (AFT-based, Minimal LLD)
#
# This landing zone uses AWS Control Tower Account Factory for Terraform (AFT)
# as the primary customization mechanism. The deployment follows this order:
#
#   1. aws-organizations  — Foundation organization structure
#   2. control-tower      — AWS Control Tower baseline (references org)
#   3. aft                — Account Factory for Terraform deployment
#
# All additional modules (KMS, VPC, GuardDuty, SecurityHub, SCPs, etc.) are
# intentionally omitted per the LLD and should be deployed via AFT
# account-level and global customizations pipelines.
# =============================================================================

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

# -----------------------------------------------------------------------------
# Step 1: AWS Organizations
# -----------------------------------------------------------------------------
module "aws_organizations" {
  source = "./modules/aws-organizations"

  organization_name    = var.organization_name
  enabled_policy_types = var.enabled_policy_types
  organizational_units = var.organizational_units
  tags                 = var.tags
}

# -----------------------------------------------------------------------------
# Step 2: Control Tower
# NOTE: AWS Control Tower must be enabled via the console or API before
# this module can manage its resources. This module creates the foundational
# references and validates the Control Tower state.
# -----------------------------------------------------------------------------
module "control_tower" {
  source = "./modules/control-tower"

  home_region            = var.home_region
  ct_management_account_id = var.ct_management_account_id
  log_archive_account_id   = var.log_archive_account_id
  audit_account_id         = var.audit_account_id
  tags                     = var.tags

  depends_on = [module.aws_organizations]
}

# -----------------------------------------------------------------------------
# Step 3: Account Factory for Terraform (AFT)
# This deploys the AFT pipeline infrastructure into the AFT Management account.
# Once deployed, all account vending and customization is driven through
# the AFT Git repositories.
# -----------------------------------------------------------------------------
module "aft" {
  source = "./modules/aft"

  # Control Tower and account references
  ct_management_account_id = var.ct_management_account_id
  log_archive_account_id   = var.log_archive_account_id
  audit_account_id         = var.audit_account_id
  aft_management_account_id = var.aft_account_id
  ct_home_region           = var.home_region

  # AFT feature flags
  aft_feature_cloudtrail_data_events = var.aft_feature_cloudtrail_data_events
  aft_feature_enterprise_support     = var.aft_feature_enterprise_support
  aft_feature_delete_default_vpcs    = var.aft_feature_delete_default_vpcs

  # Terraform configuration
  terraform_version      = var.terraform_version
  terraform_distribution = var.terraform_distribution

  # AFT VPC
  aft_vpc_cidr = var.aft_vpc_cidr

  # VCS configuration
  vcs_provider = var.vcs_provider

  account_request_repo_name    = var.account_request_repo_name
  account_request_repo_branch  = var.account_request_repo_branch

  account_customizations_repo_name    = var.account_customizations_repo_name
  account_customizations_repo_branch  = var.account_customizations_repo_branch

  account_provisioning_customizations_repo_name    = var.account_provisioning_customizations_repo_name
  account_provisioning_customizations_repo_branch  = var.account_provisioning_customizations_repo_branch

  global_customizations_repo_name    = var.global_customizations_repo_name
  global_customizations_repo_branch  = var.global_customizations_repo_branch

  tags = var.tags

  depends_on = [module.control_tower]
}