# Integration tests — apply + assert + destroy. Requires real AWS credentials.
# A public hosted zone with a single record is cheap and fast to create/destroy
# and needs no registered domain. force_destroy is on so teardown is clean.

provider "aws" {
  region = "ap-south-1"
}

variables {
  namespace     = "dvtca"
  stage         = "integ"
  name          = "route53"
  zone_name     = "integ-dvtca-route53.example.com"
  force_destroy = true

  records = {
    www = { name = "www.integ-dvtca-route53.example.com", type = "A", ttl = 300, records = ["192.0.2.1"] }
  }

  tags = {
    Environment = "integration-test"
    Ephemeral   = "true"
  }
}

run "apply_and_assert" {
  command = apply

  assert {
    condition     = aws_route53_zone.this[0].zone_id != ""
    error_message = "Hosted zone must be created with a zone ID."
  }
  assert {
    condition     = length(aws_route53_zone.this[0].name_servers) > 0
    error_message = "A public zone must expose authoritative name servers."
  }
  assert {
    condition     = length(aws_route53_record.this) == 1
    error_message = "The record must apply cleanly against the real API."
  }
}
