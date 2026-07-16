output "zone_id" {
  description = "The hosted zone ID (null when the module is disabled)."
  value       = try(aws_route53_zone.this[0].zone_id, null)
}

output "zone_arn" {
  description = "The ARN of the hosted zone (null when the module is disabled)."
  value       = try(aws_route53_zone.this[0].arn, null)
}

output "name_servers" {
  description = "The authoritative name servers for the zone. For a public zone these are the NS records you delegate to at the registrar; empty when the module is disabled."
  value       = try(aws_route53_zone.this[0].name_servers, [])
}

output "record_fqdns" {
  description = "Map of record key → fully-qualified domain name created."
  value       = { for k, r in aws_route53_record.this : k => r.fqdn }
}
