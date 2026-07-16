output "zone_id" {
  description = "The private hosted zone ID."
  value       = module.route53.zone_id
}

output "zone_arn" {
  description = "The hosted zone ARN."
  value       = module.route53.zone_arn
}

output "record_fqdns" {
  description = "Record key → FQDN created."
  value       = module.route53.record_fqdns
}
