variable "organization_name" {
  type        = string
  description = "Name of the AWS Organization"
}

variable "aws_service_access_principals" {
  type        = list(string)
  description = "AWS service access principals"
}

variable "governed_regions" {
  type        = list(string)
  description = "List of governed regions"
}

variable "management_account_id" {
  type        = string
  description = "Management account ID"
}