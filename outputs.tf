output "organization_id" {
  description = "AWS Organization ID"
  value       = module.aws_organizations.organization_id
}

output "organization_root_id" {
  description = "AWS Organization root ID"
  value       = module.aws_organizations.root_id
}

output "ou_ids" {
  description = "Map of OU names to IDs"
  value       = module.aws_organizations.ou_ids
}

output "kms_key_arns" {
  description = "Map of KMS key alias to ARN"
  value       = module.kms_keys.key_arns
}

output "hub_vpc_id" {
  description = "Hub VPC ID"
  value       = module.hub_vpc.vpc_id
}

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = module.transit_gateway.transit_gateway_id
}

output "transit_gateway_route_table_ids" {
  description = "Transit Gateway route table IDs"
  value       = module.transit_gateway.route_table_ids
}

output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = module.guardduty_org.detector_id
}

output "cloudtrail_arn" {
  description = "Organization CloudTrail ARN"
  value       = module.cloudtrail_org.cloudtrail_arn
}

output "config_recorder_id" {
  description = "AWS Config recorder ID"
  value       = module.aws_config_org.config_recorder_id
}

output "sso_permission_set_arns" {
  description = "Map of SSO permission set names to ARNs"
  value       = module.iam_identity_center.permission_set_arns
}

output "spoke_vpc_ids" {
  description = "Map of spoke VPC names to IDs"
  value = {
    shared_services = module.spoke_vpc_shared_services.vpc_id
    prod            = module.spoke_vpc_prod.vpc_id
    staging         = module.spoke_vpc_staging.vpc_id
    dev             = module.spoke_vpc_dev.vpc_id
  }
}

output "network_firewall_arn" {
  description = "Network Firewall ARN"
  value       = module.network_firewall.firewall_arn
}

output "backup_vault_arn" {
  description = "AWS Backup vault ARN"
  value       = module.aws_backup.vault_arn
}