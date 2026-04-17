variable "home_region" {
  type        = string
  description = "Home region for Control Tower"

  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-west-1", "eu-central-1", "ap-southeast-1", "ap-northeast-1"], var.home_region)
    error_message = "home_region must be an approved AWS region."
  }
}

variable "governed_regions" {
  type        = list(string)
  description = "Governed regions for Control Tower"
}

variable "log_archive_account_id" {
  type        = string
  description = "Log Archive account ID"
}

variable "audit_account_id" {
  type        = string
  description = "Audit account ID"
}

variable "organization_id" {
  type        = string
  description = "Organization ID"
}