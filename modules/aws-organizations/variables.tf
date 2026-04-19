variable "organization_name" {
  description = "Friendly name for the AWS Organization."
  type        = string

  validation {
    condition     = length(var.organization_name) >= 1 && length(var.organization_name) <= 128
    error_message = "organization_name must be between 1 and 128 characters."
  }
}

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
  description = "Map of organizational units to create."
  type = map(object({
    parent = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}