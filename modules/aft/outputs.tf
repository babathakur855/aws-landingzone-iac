output "repository_urls" {
  description = "Map of AFT CodeCommit repository clone URLs (if using codecommit)."
  value = {
    account_request                   = var.account_request_repo_name
    account_customizations            = var.account_customizations_repo_name
    account_provisioning_customizations = var.account_provisioning_customizations_repo_name
    global_customizations             = var.global_customizations_repo_name
  }
}

output "aft_management_account_id" {
  description = "AFT Management account ID."
  value       = var.aft_management_account_id
}

output "vcs_provider" {
  description = "Configured VCS provider."
  value       = var.vcs_provider
}

output "aft_vpc_cidr" {
  description = "CIDR block of the AFT VPC."
  value       = var.aft_vpc_cidr
}

output "ssm_parameters" {
  description = "SSM parameter ARNs created by this module."
  value = {
    management_account_id = aws_ssm_parameter.aft_management_account_id.arn
    vcs_provider          = aws_ssm_parameter.aft_vcs_provider.arn
    terraform_version     = aws_ssm_parameter.aft_terraform_version.arn
  }
}