output "organization_id" {
  description = "AWS Organization ID"
  value       = aws_organizations_organization.this.id
}

output "organization_arn" {
  description = "AWS Organization ARN"
  value       = aws_organizations_organization.this.arn
}

output "root_id" {
  description = "Root ID of the organization"
  value       = aws_organizations_organization.this.roots[0].id
}

output "ou_ids" {
  description = "Map of OU names to IDs"
  value = {
    security       = aws_organizations_organizational_unit.security.id
    infrastructure = aws_organizations_organizational_unit.infrastructure.id
    workloads      = aws_organizations_organizational_unit.workloads.id
    workloads_prod = aws_organizations_organizational_unit.workloads_prod.id
    workloads_staging = aws_organizations_organizational_unit.workloads_staging.id
    workloads_dev  = aws_organizations_organizational_unit.workloads_dev.id
    sandbox        = aws_organizations_organizational_unit.sandbox.id
    suspended      = aws_organizations_organizational_unit.suspended.id
  }
}