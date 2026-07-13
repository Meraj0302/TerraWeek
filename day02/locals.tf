
# Task 3 — Locals & Built-in Functions

locals {
  # join() + lower() — build a consistent naming prefix
  name_prefix = join("-", [lower(var.app_config.name), var.environment])

  # merge() — combine common tags with a computed tag
  final_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      NamePrefix  = local.name_prefix
    }
  )

  # length() — derive a value from a collection
  az_count = length(var.availability_zones)

  # upper() + format() — build a human-readable summary string
  summary = format(
    "Deploying %d x %s to %s (%s)",
    var.instance_count,
    upper(var.environment),
    local.az_count,
    join(", ", var.availability_zones)
  )

  # lookup() — safe map access with a fallback default
  owner_tag = lookup(var.common_tags, "Owner", "unassigned")

  # Bonus: for expression — transform a list
  upper_azs = [for az in var.availability_zones : upper(az)]

  # Bonus: conditional expression
  instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"
}