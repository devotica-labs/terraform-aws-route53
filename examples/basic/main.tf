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

# Uses local path during development.
# Change to Registry source after first release:
#   source  = "devotica-labs/route53/aws"
#   version = "~> 0.1"

# A public hosted zone with a single apex A-alias pointing at an ALB.
module "route53" {
  source = "../.."

  namespace = "dvtca"
  stage     = "sandbox"
  name      = "dns"

  zone_name = "sandbox.example.com"

  # An apex A-record aliased to an ALB. `alias` records omit ttl; the zone_id is
  # the ALB's canonical hosted zone ID (per region), not this hosted zone.
  records = {
    apex = {
      name = "sandbox.example.com"
      type = "A"
      alias = {
        name                   = "my-alb-1234567890.ap-south-1.elb.amazonaws.com"
        zone_id                = "ZP97RAFLXTNZK"
        evaluate_target_health = true
      }
    }
  }

  # Fintech default: force_destroy is off, so the zone can't be torn down while
  # it still resolves names.

  tags = {
    Environment = "sandbox"
    Project     = "terraform-aws-route53"
    Owner       = "platform@devotica.com"
    CostCenter  = "PLATFORM-OSS"
    ManagedBy   = "Terraform"
    Repo        = "https://github.com/devotica-labs/terraform-aws-route53"
  }
}
