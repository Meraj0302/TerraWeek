############################################
# Task 1: Providers & Version Pinning
############################################

terraform {
  required_version = ">= 1.7.0" # pin the Terraform CLI itself

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # pessimistic operator, see note below
    }
  }
}

# Primary provider / region
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "TerraWeek"
      ManagedBy = "Terraform"
    }
  }
}

# --- Bonus: a second provider alias (second region) ---
# Use an alias when a single config needs to talk to more than one
# region/account at once — e.g. replicating an S3 bucket to a DR region,
# creating a CloudFront cert (which MUST live in us-east-1) while your
# main infra lives elsewhere, or setting up cross-region peering.
provider "aws" {
  alias  = "dr"
  region = var.dr_region
}

# Example of using the aliased provider on a resource:
#   resource "aws_s3_bucket" "backup" {
#     provider = aws.dr
#     bucket   = "terraweek-dr-backup-bucket"
#   }

/*
WHY VERSION PINNING MATTERS
----------------------------
Providers and Terraform itself ship breaking changes between major versions
(e.g. AWS provider v4 -> v5 renamed/removed several resource arguments).
Without pinning, `terraform init` on a teammate's machine (or in CI, months
later) could silently pull a newer provider version and produce a different
plan, or fail to apply at all. Pinning makes builds reproducible.

WHAT "~>" (the pessimistic constraint operator) DOES
------------------------------------------------------
`~> 6.0` means: allow any version >= 6.0.0 and < 7.0.0
  - i.e. "6.x is fine, but never jump to a new major version automatically"
`~> 6.1` would instead mean >= 6.1.0 and < 6.2.0 (locks the minor version too)
This lets you pick up bug fixes / non-breaking minor updates automatically
via `terraform init -upgrade`, while protecting you from breaking changes.
The exact resolved version is then locked in `.terraform.lock.hcl`, which
you commit to version control so every apply uses the identical version.
*/
