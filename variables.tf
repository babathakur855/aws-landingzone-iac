# ─── Region Variables ─────────────────────────────────────────────
variable "home_region" {
  type        = string
  default     = "us-east-1"
  description = "Home region for the AWS Landing Zone"

  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-west-1", "eu-central-1", "ap-southeast-1", "ap-northeast-1"], var.home_region)
    error_message = "home_region must be an approved AWS region."
  }
}

variable "governed_regions" {
  type        = list(string)
  default     = ["us-east-1"]
  description = "List of governed regions for Control Tower"

  validation {
    condition     = length(var.governed_regions) > 0
    error_message = "At least one governed region must be specified."
  }
}

# ─── Organization Variables ──────────────────────────────────────
variable "organization_name" {
  type        = string
  default     = "customer-org"
  description = "Name of the AWS Organization"

  validation {
    condition     = length(var.organization_name) >= 3 && length(var.organization_name) <= 64
    error_message = "Organization name must be between 3 and 64 characters."
  }
}

variable "aws_service_access_principals" {
  type = list(string)
  default = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "sso.amazonaws.com",
    "controltower.amazonaws.com",
    "backup.amazonaws.com",
    "ram.amazonaws.com",
    "access-analyzer.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com"
  ]
  description = "AWS service access principals for the organization"
}

# ─── Account IDs ─────────────────────────────────────────────────
variable "management_account_id" {
  type        = string
  description = "Management account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.management_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

variable "log_archive_account_id" {
  type        = string
  description = "Log Archive account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.log_archive_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

variable "audit_account_id" {
  type        = string
  description = "Audit account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.audit_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

variable "security_account_id" {
  type        = string
  description = "Security tooling account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.security_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

variable "network_account_id" {
  type        = string
  description = "Network hub account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.network_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

variable "shared_services_account_id" {
  type        = string
  description = "Shared services account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.shared_services_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

variable "prod_account_id" {
  type        = string
  description = "Production workload account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.prod_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

variable "staging_account_id" {
  type        = string
  description = "Staging workload account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.staging_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

variable "dev_account_id" {
  type        = string
  description = "Development workload account ID"

  validation {
    condition     = can(regex("^\\d{12}$", var.dev_account_id))
    error_message = "Account ID must be a 12-digit number."
  }
}

# ─── Cross-Account Role ARNs ────────────────────────────────────
variable "log_archive_role_arn" {
  type        = string
  description = "IAM role ARN to assume in the Log Archive account"
}

variable "audit_role_arn" {
  type        = string
  description = "IAM role ARN to assume in the Audit account"
}

variable "security_role_arn" {
  type        = string
  description = "IAM role ARN to assume in the Security account"
}

variable "network_role_arn" {
  type        = string
  description = "IAM role ARN to assume in the Network account"
}

variable "shared_services_role_arn" {
  type        = string
  description = "IAM role ARN to assume in the Shared Services account"
}

variable "prod_role_arn" {
  type        = string
  description = "IAM role ARN to assume in the Production account"
}

variable "staging_role_arn" {
  type        = string
  description = "IAM role ARN to assume in the Staging account"
}

variable "dev_role_arn" {
  type        = string
  description = "IAM role ARN to assume in the Dev account"
}

# ─── Networking Variables ────────────────────────────────────────
variable "hub_vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the Hub VPC"

  validation {
    condition     = can(cidrhost(var.hub_vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "shared_services_vpc_cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "CIDR block for Shared Services VPC"

  validation {
    condition     = can(cidrhost(var.shared_services_vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "prod_vpc_cidr" {
  type        = string
  default     = "10.2.0.0/16"
  description = "CIDR block for Production VPC"

  validation {
    condition     = can(cidrhost(var.prod_vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "staging_vpc_cidr" {
  type        = string
  default     = "10.3.0.0/16"
  description = "CIDR block for Staging VPC"

  validation {
    condition     = can(cidrhost(var.staging_vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "dev_vpc_cidr" {
  type        = string
  default     = "10.4.0.0/16"
  description = "CIDR block for Development VPC"

  validation {
    condition     = can(cidrhost(var.dev_vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "tgw_amazon_side_asn" {
  type        = number
  default     = 64512
  description = "Amazon side ASN for Transit Gateway"

  validation {
    condition     = var.tgw_amazon_side_asn >= 64512 && var.tgw_amazon_side_asn <= 65534
    error_message = "ASN must be in the private range 64512-65534."
  }
}

# ─── SSO / Identity Variables ───────────────────────────────────
variable "sso_provider_name" {
  type        = string
  default     = "CorporateIdP"
  description = "Name of the corporate identity provider"
}

variable "sso_instance_arn" {
  type        = string
  description = "ARN of the IAM Identity Center instance"
  default     = ""
}

variable "identity_store_id" {
  type        = string
  description = "Identity Store ID for IAM Identity Center"
  default     = ""
}

# ─── Budget Variables ───────────────────────────────────────────
variable "monthly_budget_limit" {
  type        = string
  default     = "10000"
  description = "Monthly budget limit in USD"
}

variable "budget_alert_emails" {
  type        = list(string)
  default     = ["cloud-finance@example.com"]
  description = "Email addresses for budget alerts"
}

# ─── SNS Variables ──────────────────────────────────────────────
variable "security_notification_emails" {
  type        = list(string)
  default     = ["security-team@example.com"]
  description = "Email addresses for security notifications"
}

variable "ops_notification_emails" {
  type        = list(string)
  default     = ["ops-team@example.com"]
  description = "Email addresses for operational notifications"
}

# ─── Tagging ────────────────────────────────────────────────────
variable "mandatory_tags" {
  type = map(string)
  default = {
    CostCenter  = "Platform"
    Owner       = "CloudTeam"
    Environment = "management"
  }
  description = "Mandatory tags for all resources"
}

# ─── AFT Variables ──────────────────────────────────────────────
variable "aft_management_account_id" {
  type        = string
  default     = ""
  description = "Account ID for AFT management (can be same as management account)"
}

variable "aft_vpc_cidr" {
  type        = string
  default     = "10.100.0.0/22"
  description = "CIDR block for the AFT VPC"
}

variable "ct_management_account_id" {
  type        = string
  default     = ""
  description = "Control Tower management account ID (typically same as management_account_id)"
}

# ─── Backup Variables ──────────────────────────────────────────
variable "backup_schedule" {
  type        = string
  default     = "cron(0 5 ? * * *)"
  description = "Cron expression for backup schedule"
}

variable "backup_retention_days" {
  type        = number
  default     = 35
  description = "Number of days to retain backups"

  validation {
    condition     = var.backup_retention_days >= 7 && var.backup_retention_days <= 365
    error_message = "Backup retention must be between 7 and 365 days."
  }
}

# ─── Patch Manager Variables ────────────────────────────────────
variable "patch_schedule" {
  type        = string
  default     = "cron(0 2 ? * SUN *)"
  description = "Cron expression for patching schedule"
}

variable "patch_approval_days" {
  type        = number
  default     = 7
  description = "Days after release to auto-approve patches"

  validation {
    condition     = var.patch_approval_days >= 0 && var.patch_approval_days <= 30
    error_message = "Patch approval days must be between 0 and 30."
  }
}