# Changelog

All notable changes to this module are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the module
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Releases are cut automatically by `release-please` on merge to `main`,
driven by Conventional Commit prefixes (`feat:` → minor, `fix:`/`docs:`/`chore:` → patch,
`feat!:`/`BREAKING CHANGE:` → major).

## 0.1.0 (2026-07-16)


### Features

* **ci:** add architecture-diagram workflow + renderer ([8facae6](https://github.com/devotica-labs/terraform-aws-route53/commit/8facae6eaab72b6d2f46f3a759741432db912ad3))
* initial release of terraform-aws-route53 ([779d8f4](https://github.com/devotica-labs/terraform-aws-route53/commit/779d8f4b99d261b0bfb864a74b9325122a939296))


### Bug Fixes

* **ci:** drop dead pip/scripts dependabot entry; tflint clean ([fadd5de](https://github.com/devotica-labs/terraform-aws-route53/commit/fadd5def512f02986101834ef162ec18985e7531))

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
