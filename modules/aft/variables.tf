# =============================================================================
# AFT Module Variables
# =============================================================================

variable "ct_management_account_id" {
  description = "Control Tower management account ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.ct_management_account_id))
    error_message = "ct_management_account_id must be a 12-digit AWS account ID."
  }
}

variable "log_archive_account_id" {
  description = "Log Archive account ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.log_archive_account_id))
    error_message = "log_archive_account_id must be a 12-digit AWS account ID."
  }
}

variable "audit_account_id" {
  description = "Audit account ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.audit_account_id))
    error_message = "audit_account_id must be a 12-digit AWS account ID."
  }
}

variable "aft_management_account_id" {
  description = "AFT Management account ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aft_management_account_id))
    error_message = "aft_management_account_id must be a 12-digit AWS account ID."
  }
}

variable "ct_home_region" {
  description = "Control Tower home region."
  type        = string

  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-west-1", "eu-central-1", "ap-southeast-1", "ap-northeast-1"], var.ct_home_region)
    error_message = "ct_home_region must be an approved AWS region."
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
    error_message = "terraform_version must be a valid semantic version."
  }
}

variable "terraform_distribution" {
  description = "Terraform distribution for AFT."
  type        = string
  default     = "oss"

  validation {
    condition     = contains(["oss", "tfc"], var.terraform_distribution)
    error_message = "terraform_distribution must be 'oss' or 'tfc'."
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

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}