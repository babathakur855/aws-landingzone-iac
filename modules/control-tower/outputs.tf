output "landing_zone_status" {
  description = "Control Tower landing zone validation status."
  value       = local.landing_zone_status
}

output "management_account_id" {
  description = "Management account ID."
  value       = data.aws_caller_identity.management.account_id
}

output "home_region" {
  description = "Control Tower home region."
  value       = var.home_region
}

output "ssm_parameter_arns" {
  description = "ARNs of all SSM parameters created."
  value = {
    home_region        = aws_ssm_parameter.ct_home_region.arn
    management_account = aws_ssm_parameter.ct_management_account_id.arn
    log_archive        = aws_ssm_parameter.ct_log_archive_account_id.arn
    audit              = aws_ssm_parameter.ct_audit_account_id.arn
    status             = aws_ssm_parameter.ct_landing_zone_status.arn
  }
}