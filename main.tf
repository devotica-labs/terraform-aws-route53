# A Route 53 hosted zone plus a map of records. The zone is PUBLIC by default;
# supplying var.vpc_ids attaches one or more VPCs and makes it PRIVATE. Fintech
# default: force_destroy off, so a zone that still resolves names can't be torn
# down by accident.
resource "aws_route53_zone" "this" {
  count = local.enabled ? 1 : 0

  name          = var.zone_name
  comment       = var.comment
  force_destroy = var.force_destroy

  # One vpc block per associated VPC. Presence of any block makes the zone private.
  dynamic "vpc" {
    for_each = var.vpc_ids
    content {
      vpc_id = vpc.value
    }
  }

  tags = local.tags
}

# One record per entry in var.records. Plain records carry ttl + records; alias
# records render a dynamic "alias" block instead and omit ttl.
resource "aws_route53_record" "this" {
  for_each = local.enabled ? var.records : {}

  zone_id = aws_route53_zone.this[0].zone_id
  name    = each.value.name
  type    = each.value.type

  # ttl / records apply only to plain records; must be null/absent for alias.
  ttl     = each.value.alias == null ? each.value.ttl : null
  records = each.value.alias == null ? each.value.records : null

  dynamic "alias" {
    for_each = each.value.alias == null ? [] : [each.value.alias]
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
