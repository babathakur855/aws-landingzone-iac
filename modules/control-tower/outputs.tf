output "landing_zone_id" {
  description = "Control Tower Landing Zone ID"
  value       = aws_controltower_landing_zone.this.id
}

output "landing_zone_arn" {
  description = "Control Tower Landing Zone ARN"
  value       = aws_controltower_landing_zone.this.arn
}