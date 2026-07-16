output "zone_id" {
  description = "The hosted zone ID."
  value       = module.route53.zone_id
}

output "name_servers" {
  description = "Authoritative name servers to delegate to at the registrar."
  value       = module.route53.name_servers
}

output "record_fqdns" {
  description = "Record key → FQDN created."
  value       = module.route53.record_fqdns
}
