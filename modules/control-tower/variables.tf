variable "home_region" {
  description = "Control Tower home region."
  type        = string

  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-west-1", "eu-central-1", "ap-southeast-1", "ap-northeast-1"], var.home_region)
    error_message = "home_region must be an approved AWS region."
  }
}

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
    condition     = var.log_archive_account_id == "" || can(regex("^[0-9]{12}$", var.log_archive_account_id))
    error_message = "log_archive_account_id must be a 12-digit AWS account ID or empty string."
  }
}

variable "audit_account_id" {
  description = "Audit account ID."
  type        = string

  validation {
    condition     = var.audit_account_id == "" || can(regex("^[0-9]{12}$", var.audit_account_id))
    error_message = "audit_account_id must be a 12-digit AWS account ID or empty string."
  }
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}