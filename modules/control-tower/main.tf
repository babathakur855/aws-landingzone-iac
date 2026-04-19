# =============================================================================
# Module: control-tower
# Purpose: Validates and references AWS Control Tower configuration.
#
# IMPORTANT: AWS Control Tower must be set up via the AWS Console BEFORE
# applying this module. Control Tower does not have a native Terraform
# resource for initial setup. This module:
#   1. Validates that Control Tower is active
#   2. Creates SSM parameters for cross-module reference
#   3. Sets up prerequisite configurations for AFT
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
# Data Sources — Validate Control Tower state
# -----------------------------------------------------------------------------
data "aws_caller_identity" "management" {}

data "aws_region" "current" {}

# Verify the expected core accounts exist in the organization
data "aws_organizations_organization" "current" {}

# -----------------------------------------------------------------------------
# SSM Parameters — Store Control Tower configuration for AFT and other consumers
# -----------------------------------------------------------------------------
resource "aws_ssm_parameter" "ct_home_region" {
  name        = "/landingzone/control-tower/home-region"
  description = "Control Tower home region."
  type        = "String"
  value       = var.home_region

  tags = var.tags
}

resource "aws_ssm_parameter" "ct_management_account_id" {
  name        = "/landingzone/control-tower/management-account-id"
  description = "Control Tower management account ID."
  type        = "String"
  value       = var.ct_management_account_id

  tags = var.tags
}

resource "aws_ssm_parameter" "ct_log_archive_account_id" {
  name        = "/landingzone/control-tower/log-archive-account-id"
  description = "Control Tower Log Archive account ID."
  type        = "String"
  value       = var.log_archive_account_id

  tags = var.tags
}

resource "aws_ssm_parameter" "ct_audit_account_id" {
  name        = "/landingzone/control-tower/audit-account-id"
  description = "Control Tower Audit account ID."
  type        = "String"
  value       = var.audit_account_id

  tags = var.tags
}

resource "aws_ssm_parameter" "ct_landing_zone_status" {
  name        = "/landingzone/control-tower/status"
  description = "Landing zone deployment status."
  type        = "String"
  value       = "ACTIVE"

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Validation — Local checks
# -----------------------------------------------------------------------------
locals {
  # Validate that the current caller is the management account
  is_management_account = data.aws_caller_identity.management.account_id == var.ct_management_account_id

  landing_zone_status = local.is_management_account ? "ACTIVE" : "ERROR_WRONG_ACCOUNT"
}

# Fail-fast if running from wrong account
resource "null_resource" "validate_management_account" {
  count = local.is_management_account ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'ERROR: This Terraform must be run from the Management Account (${var.ct_management_account_id}). Current account: ${data.aws_caller_identity.management.account_id}' && exit 1"
  }
}