locals {
  # A non-empty VPC association list makes the hosted zone private.
  is_private = length(var.vpc_ids) > 0
}
