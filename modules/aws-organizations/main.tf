# =============================================================================
# Module: aws-organizations
# Purpose: Creates and configures AWS Organizations with OUs and policy types.
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
# AWS Organization
# -----------------------------------------------------------------------------
resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "controltower.amazonaws.com",
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "sso.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
    "backup.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
  ]

  enabled_policy_types = var.enabled_policy_types

  feature_set = "ALL"
}

# -----------------------------------------------------------------------------
# Organization Root (data source — the root is auto-created with the org)
# -----------------------------------------------------------------------------
locals {
  root_id = aws_organizations_organization.this.roots[0].id
}

# -----------------------------------------------------------------------------
# Organizational Units
# We build OUs in two passes:
#   1. Root-level OUs (parent = "root")
#   2. Child OUs (parent references another OU name)
# This handles a single level of nesting which is typical for landing zones.
# -----------------------------------------------------------------------------

# Pass 1: Root-level OUs
resource "aws_organizations_organizational_unit" "root_level" {
  for_each = {
    for name, config in var.organizational_units : name => config
    if config.parent == "root"
  }

  name      = each.key
  parent_id = local.root_id

  tags = merge(var.tags, {
    Name = each.key
  })

  lifecycle {
    # Prevent accidental OU deletion which would affect all member accounts
    prevent_destroy = false # Set to true in production
  }
}

# Pass 2: Child OUs (one level deep)
resource "aws_organizations_organizational_unit" "child_level" {
  for_each = {
    for name, config in var.organizational_units : name => config
    if config.parent != "root"
  }

  name      = each.key
  parent_id = aws_organizations_organizational_unit.root_level[each.value.parent].id

  tags = merge(var.tags, {
    Name       = each.key
    ParentOU   = each.value.parent
  })

  lifecycle {
    prevent_destroy = false # Set to true in production
  }
}

# Build a combined map of all OU IDs for output
locals {
  all_ou_ids = merge(
    { for name, ou in aws_organizations_organizational_unit.root_level : name => ou.id },
    { for name, ou in aws_organizations_organizational_unit.child_level : name => ou.id },
  )
}