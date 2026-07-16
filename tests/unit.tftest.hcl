# Plan-only unit tests — no AWS credentials required. No IAM policy documents are
# rendered by this module, so a bare mock provider is enough.

mock_provider "aws" {}

variables {
  namespace = "dvtca"
  stage     = "test"
  name      = "unit"

  zone_name = "example.com"

  records = {
    www = { name = "www.example.com", type = "A", ttl = 300, records = ["192.0.2.1"] }
    txt = { name = "example.com", type = "TXT", ttl = 300, records = ["v=spf1 -all"] }
  }
}

run "zone_planned" {
  command = plan
  assert {
    condition     = length(aws_route53_zone.this) == 1
    error_message = "Exactly one hosted zone must be planned."
  }
}

run "records_match_map_cardinality" {
  command = plan
  assert {
    condition     = length(aws_route53_record.this) == 2
    error_message = "One record resource must be planned per entry in var.records."
  }
}

run "public_zone_by_default" {
  command = plan
  assert {
    condition     = length(aws_route53_zone.this[0].vpc) == 0
    error_message = "With no vpc_ids the zone must be public (no vpc blocks)."
  }
}

run "private_zone_when_vpc_ids_supplied" {
  # apply so the mock provider materializes the vpc set (its elements carry
  # computed attributes, so its length is unknown at plan time).
  command = apply
  variables {
    vpc_ids = ["vpc-0aa11bb22cc33dd44", "vpc-0ee55ff66gg77hh88"]
  }
  assert {
    condition     = length(aws_route53_zone.this[0].vpc) == 2
    error_message = "A non-empty vpc_ids list must attach one vpc block per VPC (private zone)."
  }
}

run "alias_record_omits_ttl" {
  command = plan
  variables {
    records = {
      apex = {
        name = "example.com"
        type = "A"
        alias = {
          name                   = "my-alb-123.ap-south-1.elb.amazonaws.com"
          zone_id                = "ZP97RAFLXTNZK"
          evaluate_target_health = true
        }
      }
    }
  }
  assert {
    condition     = one([for r in aws_route53_record.this : length(r.alias)]) == 1
    error_message = "An alias record must render exactly one alias block."
  }
  assert {
    condition     = one([for r in aws_route53_record.this : r.ttl]) == null
    error_message = "Alias records must not set a ttl."
  }
}

run "disabled_creates_nothing" {
  command = plan
  variables {
    enabled = false
  }
  assert {
    condition     = length(aws_route53_zone.this) == 0
    error_message = "enabled = false must create no hosted zone."
  }
  assert {
    condition     = length(aws_route53_record.this) == 0
    error_message = "enabled = false must create no records."
  }
}
