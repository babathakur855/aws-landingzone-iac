output "organization_id" {
  description = "The ID of the AWS Organization."
  value       = aws_organizations_organization.this.id
}

output "organization_arn" {
  description = "The ARN of the AWS Organization."
  value       = aws_organizations_organization.this.arn
}

output "root_id" {
  description = "The ID of the organization root."
  value       = local.root_id
}

output "master_account_id" {
  description = "The account ID of the management account."
  value       = aws_organizations_organization.this.master_account_id
}

output "ou_ids" {
  description = "Map of OU names to their IDs."
  value       = local.all_ou_ids
}

output "root_level_ous" {
  description = "Map of root-level OU names to their full resource attributes."
  value       = aws_organizations_organizational_unit.root_level
}

output "non_root_accounts" {
  description = "List of non-management account IDs in the organization."
  value       = aws_organizations_organization.this.non_master_accounts
}