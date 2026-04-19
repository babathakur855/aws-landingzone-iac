# ═══════════════════════════════════════════════════════════════════
# Control Tower Module
# ═══════════════════════════════════════════════════════════════════

resource "aws_controltower_landing_zone" "this" {
  manifest_json = jsonencode({
    governedRegions = var.governed_regions
    organizationStructure = {
      security = {
        name = "Security"
      }
      sandbox = {
        name = "Sandbox"
      }
    }
    centralizedLogging = {
      accountId = var.log_archive_account_id
      configurations = {
        loggingBucket = {
          retentionDays = 365
        }
        accessLoggingBucket = {
          retentionDays = 365
        }
      }
      enabled = true
    }
    securityRoles = {
      accountId = var.audit_account_id
    }
    accessManagement = {
      enabled = true
    }
  })

  version = "3.3"
}

# ─── Control Tower Controls (Guardrails) ───────────────────────
locals {
  preventive_controls = [
    "AWS-GR_RESTRICT_ROOT_USER_ACCESS_KEYS",
    "AWS-GR_RESTRICT_S3_DELETE_WITHOUT_MFA",
    "AWS-GR_ENCRYPTED_VOLUMES",
    "AWS-GR_RDS_INSTANCE_PUBLIC_ACCESS_CHECK",
    "AWS-GR_RESTRICT_S3_CROSS_REGION_REPLICATION",
    "AWS-GR_EBS_OPTIMIZED_INSTANCE",
    "AWS-GR_RDS_STORAGE_ENCRYPTED",
    "AWS-GR_RESTRICTED_COMMON_PORTS"
  ]

  detective_controls = [
    "AWS-GR_DETECT_CLOUDTRAIL_ENABLED_ON_MEMBER_ACCOUNTS",
    "AWS-GR_DETECT_CLOUDTRAIL_ENABLED_ON_SHARED_ACCOUNTS"
  ]
}