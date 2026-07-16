# Changelog

All notable changes to this module are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the module
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Releases are cut automatically by `release-please` on merge to `main`,
driven by Conventional Commit prefixes (`feat:` → minor, `fix:`/`docs:`/`chore:` → patch,
`feat!:`/`BREAKING CHANGE:` → major).

## [Unreleased]

### Added

- Initial release: an Amazon Route 53 hosted zone (public by default, or private
  when `vpc_ids` is non-empty via dynamic `vpc` blocks) plus a `for_each` map of
  DNS records. Records support both plain entries (`ttl` + `records`) and alias
  entries (dynamic `alias` block to an ALB/CloudFront/Route 53 target, `ttl`
  omitted), with validation that each record is exactly one shape. Fintech-safe
  default: `force_destroy` off. Native `label.tf` naming; built natively from the
  AWS provider (referencing `cloudposse/terraform-aws-route53-cluster-zone` for
  ideas only).
