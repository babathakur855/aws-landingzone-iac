# ═══════════════════════════════════════════════════════════════════
# AWS Organizations Module
# ═══════════════════════════════════════════════════════════════════

resource "aws_organizations_organization" "this" {
  aws_service_access_principals = var.aws_service_access_principals
  feature_set                   = "ALL"

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
    "BACKUP_POLICY"
  ]
}

# ─── Organizational Units ───────────────────────────────────────
resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "Infrastructure"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads_prod" {
  name      = "Prod"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_staging" {
  name      = "Staging"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "workloads_dev" {
  name      = "Dev"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "suspended" {
  name      = "Suspended"
  parent_id = aws_organizations_organization.this.roots[0].id
}

# ─── Delegated Administrators ──────────────────────────────────
resource "aws_organizations_delegated_administrator" "guardduty" {
  account_id        = var.management_account_id
  service_principal = "guardduty.amazonaws.com"

  depends_on = [aws_organizations_organization.this]
}

resource "aws_organizations_delegated_administrator" "securityhub" {
  account_id        = var.management_account_id
  service_principal = "securityhub.amazonaws.com"

  depends_on = [aws_organizations_organization.this]
}

resource "aws_organizations_delegated_administrator" "config" {
  account_id        = var.management_account_id
  service_principal = "config.amazonaws.com"

  depends_on = [aws_organizations_organization.this]
}

# ─── Tag Policy ─────────────────────────────────────────────────
resource "aws_organizations_policy" "mandatory_tags" {
  name        = "MandatoryTagPolicy"
  description = "Enforce mandatory tags across the organization"
  type        = "TAG_POLICY"

  content = jsonencode({
    tags = {
      CostCenter = {
        tag_key = {
          "@@assign" = "CostCenter"
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "ec2:volume",
            "rds:db",
            "s3:bucket"
          ]
        }
      }
      Environment = {
        tag_key = {
          "@@assign" = "Environment"
        }
        tag_value = {
          "@@assign" = ["prod", "staging", "dev", "shared-services", "management", "security", "network"]
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "ec2:volume",
            "rds:db",
            "s3:bucket"
          ]
        }
      }
      Owner = {
        tag_key = {
          "@@assign" = "Owner"
        }
        enforced_for = {
          "@@assign" = [
            "ec2:instance",
            "s3:bucket"
          ]
        }
      }
    }
  })
}

resource "aws_organizations_policy_attachment" "mandatory_tags_root" {
  policy_id = aws_organizations_policy.mandatory_tags.id
  target_id = aws_organizations_organization.this.roots[0].id
}