# ---------------------------------------------------------------------------
# Hosted zone
# ---------------------------------------------------------------------------
variable "zone_name" {
  type        = string
  description = "The domain name for the hosted zone (e.g. \"example.com\" or \"internal.example.com\")."

  validation {
    condition     = length(trimspace(var.zone_name)) > 0
    error_message = "zone_name must be a non-empty domain name."
  }
}

variable "vpc_ids" {
  type        = list(string)
  description = "VPC IDs to associate with the zone. A non-empty list makes the zone PRIVATE (resolvable only inside the associated VPCs); an empty list (default) creates a PUBLIC zone."
  default     = []
}

variable "comment" {
  type        = string
  description = "Comment attached to the hosted zone."
  default     = "Managed by Terraform"
}

variable "force_destroy" {
  type        = bool
  description = "Destroy the zone even if it still contains records not managed by Terraform. Fintech default is false — deleting a zone that still resolves names should be a deliberate act."
  default     = false
}

# ---------------------------------------------------------------------------
# Records
# ---------------------------------------------------------------------------
variable "records" {
  type = map(object({
    name    = string
    type    = string
    ttl     = optional(number)
    records = optional(list(string))
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, false)
    }))
  }))
  description = <<-EOT
    Map of DNS records to create in the zone, keyed by an arbitrary stable id.
    Each entry is either a plain record (set `ttl` + `records`) or an alias
    record (set `alias = { name, zone_id, evaluate_target_health }`) — never
    both. `ttl` is omitted for alias records. Example:

      {
        www  = { name = "www.example.com", type = "A", ttl = 300, records = ["192.0.2.1"] }
        apex = { name = "example.com", type = "A", alias = { name = "my-alb-123.ap-south-1.elb.amazonaws.com", zone_id = "ZM7...", evaluate_target_health = true } }
      }
  EOT
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.records : (v.alias != null) != (v.records != null)])
    error_message = "Each record must set exactly one of `alias` or `records` (not both, not neither)."
  }

  validation {
    condition     = alltrue([for k, v in var.records : v.records == null || v.ttl != null])
    error_message = "Plain (non-alias) records must set `ttl`."
  }
}
