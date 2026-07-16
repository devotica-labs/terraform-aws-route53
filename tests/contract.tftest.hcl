# Contract tests — the zone-name passthrough and safety defaults stay stable
# across versions.

mock_provider "aws" {}

variables {
  namespace = "dvtca"
  stage     = "test"
  name      = "contract"

  zone_name = "contract.example.com"

  records = {
    www = { name = "www.contract.example.com", type = "A", ttl = 300, records = ["192.0.2.10"] }
  }
}

run "zone_name_passthrough" {
  command = plan
  assert {
    condition     = aws_route53_zone.this[0].name == "contract.example.com"
    error_message = "zone_name must pass through verbatim to the hosted zone."
  }
}

run "force_destroy_defaults_false" {
  command = plan
  assert {
    condition     = aws_route53_zone.this[0].force_destroy == false
    error_message = "force_destroy must default to false."
  }
}
