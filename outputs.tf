# =============================================================================
# Root Outputs
# =============================================================================

output "organization_id" {
  description = "AWS Organization ID."
  value       = module.aws_organizations.organization_id
}

output "organization_root_id" {
  description = "AWS Organization root ID."
  value       = module.aws_organizations.root_id
}

output "organizational_unit_ids" {
  description = "Map of OU names to their IDs."
  value       = module.aws_organizations.ou_ids
}

output "control_tower_landing_zone_status" {
  description = "Control Tower landing zone validation status."
  value       = module.control_tower.landing_zone_status
}

output "aft_account_id" {
  description = "AFT Management account ID."
  value       = var.aft_account_id
}

output "aft_codecommit_repos" {
  description = "AFT CodeCommit repository URLs (if using codecommit VCS provider)."
  value       = module.aft.repository_urls
}

output "home_region" {
  description = "Landing zone home region."
  value       = var.home_region
}

output "management_account_id" {
  description = "Management account ID."
  value       = data.aws_caller_identity.current.account_id
}