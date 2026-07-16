# ---------------------------------------------------------------------------
# Provider block — CI-friendly skip flags + non-AWS-shaped placeholder creds.
# ---------------------------------------------------------------------------
provider "aws" {
  region                      = "ap-south-1"
  access_key                  = "not-a-real-aws-key"
  secret_key                  = "not-a-real-aws-secret"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# A PRIVATE hosted zone resolvable inside the given VPCs, holding a mix of plain
# record types: an A record for a database endpoint, a CNAME for an internal
# service, and a TXT record for domain verification.
module "route53" {
  source = "../.."

  namespace = "dvtca"
  stage     = "prod"
  name      = "internal"

  zone_name = "internal.payments.example.com"
  comment   = "Private zone for internal payments services"

  # Non-empty vpc_ids makes the zone private and associates it with these VPCs.
  vpc_ids = [
    "vpc-0aa11bb22cc33dd44",
    "vpc-0ee55ff66gg77hh88",
  ]

  # Fintech default: keep force_destroy off in production.
  force_destroy = false

  records = {
    db = {
      name    = "db.internal.payments.example.com"
      type    = "A"
      ttl     = 300
      records = ["10.0.12.34"]
    }
    cache = {
      name    = "cache.internal.payments.example.com"
      type    = "CNAME"
      ttl     = 300
      records = ["my-redis.abc123.ng.0001.aps1.cache.amazonaws.com"]
    }
    verification = {
      name    = "internal.payments.example.com"
      type    = "TXT"
      ttl     = 3600
      records = ["v=spf1 -all", "payments-domain-verification=abc123def456"]
    }
  }

  tags = {
    Environment = "prod"
    Project     = "terraform-aws-route53"
    Owner       = "platform@devotica.com"
    CostCenter  = "PLATFORM-OSS"
    ManagedBy   = "Terraform"
    Repo        = "https://github.com/devotica-labs/terraform-aws-route53"
  }
}
