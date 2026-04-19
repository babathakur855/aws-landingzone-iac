# =============================================================================
# Core Configuration
# =============================================================================

variable "home_region" {
  description = "Primary AWS region for the landing zone and AFT deployment."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-west-1", "eu-central-1", "ap-southeast-1", "ap-northeast-1"], var.home_region)
    error_message = "home_region must be an approved AWS region."
  }
}

variable "organization_name" {
  description = "Friendly name for the AWS Organization."
  type        = string
  default     = "landing-zone-org"

  validation {
    condition     = length(var.organization_name) >= 1 && length(var.organization_name) <= 128
    error_message = "organization_name must be between 1 and 128 characters."
  }
}

# =============================================================================
# Cross-Account Role ARNs
# =============================================================================

variable "log_archive_role_arn" {
  description = "IAM role ARN to assume in the Log Archive account."
  type        = string
  default     = ""

  validation {
    condition     = var.log_archive_role_arn == "" || can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.log_archive_role_arn))
    error_message = "log_archive_role_arn must be a valid IAM role ARN or empty string."
  }
}

variable "audit_role_arn" {
  description = "IAM role ARN to assume in the Audit account."
  type        = string
  default     = ""

  validation {
    condition     = var.audit_role_arn == "" || can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.audit_role_arn))
    error_message = "audit_role_arn must be a valid IAM role ARN or empty string."
  }
}

variable "security_role_arn" {
  description = "IAM role ARN to assume in the Security account."
  type        = string
  default     = ""

  validation {
    condition     = var.security_role_arn == "" || can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.security_role_arn))
    error_message = "security_role_arn must be a valid IAM role ARN or empty string."
  }
}

variable "network_role_arn" {
  description = "IAM role ARN to assume in the Network account."
  type        = string
  default     = ""

  validation {
    condition     = var.network_role_arn == "" || can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.network_role_arn))
    error_message = "network_role_arn must be a valid IAM role ARN or empty string."
  }
}

variable "aft_management_role_arn" {
  description = "IAM role ARN to assume in the AFT Management account."
  type        = string
  default     = ""

  validation {
    condition     = var.aft_management_role_arn == "" || can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.aft_management_role_arn))
    error_message = "aft_management_role_arn must be a valid IAM role ARN or empty string."
  }
}

# =============================================================================
# AWS Organizations Configuration
# =============================================================================

variable "enabled_policy_types" {
  description = "List of Organizations policy types to enable."
  type        = list(string)
  default     = ["SERVICE_CONTROL_POLICY", "TAG_POLICY"]

  validation {
    condition = alltrue([
      for pt in var.enabled_policy_types : contains([
        "SERVICE_CONTROL_POLICY",
        "TAG_POLICY",
        "BACKUP_POLICY",
        "AISERVICES_OPT_OUT_POLICY"
      ], pt)
    ])
    error_message = "Each policy type must be one of: SERVICE_CONTROL_POLICY, TAG_POLICY, BACKUP_POLICY, AISERVICES_OPT_OUT_POLICY."
  }
}

variable "organizational_units" {
  description = "Map of organizational units to create. Key is OU name, value is parent OU name (use 'root' for top-level)."
  type = map(object({
    parent = string
  }))
  default = {
    "Security" = {
      parent = "root"
    }
    "Infrastructure" = {
      parent = "root"
    }
    "Sandbox" = {
      parent = "root"
    }
    "Workloads" = {
      parent = "root"
    }
    "PolicyStaging" = {
      parent = "root"
    }
    "Suspended" = {
      parent = "root"
    }
  }
}

# =============================================================================
# AFT Configuration
# =============================================================================

variable "aft_account_id" {
  description = "AWS Account ID for the AFT Management account."
  type        = string
  default     = ""

  validation {
    condition     = var.aft_account_id == "" || can(regex("^[0-9]{12}$", var.aft_account_id))
    error_message = "aft_account_id must be a 12-digit AWS account ID or empty string."
  }
}

variable "ct_management_account_id" {
  description = "AWS Account ID for the Control Tower Management account (current account)."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.ct_management_account_id))
    error_message = "ct_management_account_id must be a 12-digit AWS account ID."
  }
}

variable "log_archive_account_id" {
  description = "AWS Account ID for the Log Archive account."
  type        = string
  default     = ""

  validation {
    condition     = var.log_archive_account_id == "" || can(regex("^[0-9]{12}$", var.log_archive_account_id))
    error_message = "log_archive_account_id must be a 12-digit AWS account ID or empty string."
  }
}

variable "audit_account_id" {
  description = "AWS Account ID for the Audit account."
  type        = string
  default     = ""

  validation {
    condition     = var.audit_account_id == "" || can(regex("^[0-9]{12}$", var.audit_account_id))
    error_message = "audit_account_id must be a 12-digit AWS account ID or empty string."
  }
}

variable "aft_vpc_cidr" {
  description = "CIDR block for the AFT VPC."
  type        = string
  default     = "10.0.0.0/22"

  validation {
    condition     = can(cidrhost(var.aft_vpc_cidr, 0))
    error_message = "aft_vpc_cidr must be a valid CIDR block."
  }
}

variable "aft_feature_cloudtrail_data_events" {
  description = "Enable CloudTrail data events in AFT."
  type        = bool
  default     = false
}

variable "aft_feature_enterprise_support" {
  description = "Enable Enterprise Support in AFT-provisioned accounts."
  type        = bool
  default     = false
}

variable "aft_feature_delete_default_vpcs" {
  description = "Delete default VPCs in AFT-provisioned accounts."
  type        = bool
  default     = true
}

variable "terraform_version" {
  description = "Terraform version for AFT pipelines."
  type        = string
  default     = "1.6.6"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.terraform_version))
    error_message = "terraform_version must be a valid semantic version (e.g., 1.6.6)."
  }
}

variable "terraform_distribution" {
  description = "Terraform distribution for AFT (oss or tfc)."
  type        = string
  default     = "oss"

  validation {
    condition     = contains(["oss", "tfc"], var.terraform_distribution)
    error_message = "terraform_distribution must be 'oss' or 'tfc'."
  }
}

# =============================================================================
# AFT VCS (Version Control) Configuration
# =============================================================================

variable "vcs_provider" {
  description = "VCS provider for AFT repositories."
  type        = string
  default     = "codecommit"

  validation {
    condition     = contains(["codecommit", "github", "githubenterprise", "bitbucket"], var.vcs_provider)
    error_message = "vcs_provider must be one of: codecommit, github, githubenterprise, bitbucket."
  }
}

variable "account_request_repo_name" {
  description = "Repository name for AFT account requests."
  type        = string
  default     = "aft-account-request"
}

variable "account_request_repo_branch" {
  description = "Branch name for AFT account request repository."
  type        = string
  default     = "main"
}

variable "account_customizations_repo_name" {
  description = "Repository name for AFT account customizations."
  type        = string
  default     = "aft-account-customizations"
}

variable "account_customizations_repo_branch" {
  description = "Branch name for AFT account customizations repository."
  type        = string
  default     = "main"
}

variable "account_provisioning_customizations_repo_name" {
  description = "Repository name for AFT account provisioning customizations."
  type        = string
  default     = "aft-account-provisioning-customizations"
}

variable "account_provisioning_customizations_repo_branch" {
  description = "Branch name for AFT account provisioning customizations repository."
  type        = string
  default     = "main"
}

variable "global_customizations_repo_name" {
  description = "Repository name for AFT global customizations."
  type        = string
  default     = "aft-global-customizations"
}

variable "global_customizations_repo_branch" {
  description = "Branch name for AFT global customizations repository."
  type        = string
  default     = "main"
}

# =============================================================================
# Tags
# =============================================================================

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Project     = "AWS-Landing-Zone"
    Compliance  = "Baseline"
  }
}