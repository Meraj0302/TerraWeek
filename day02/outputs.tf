# Task 3 — Outputs

output "name_prefix" {
  description = "Computed naming prefix used across resources"
  value       = local.name_prefix
}

output "final_tags" {
  description = "Merged tag set applied to resources"
  value       = local.final_tags
}

output "deployment_summary" {
  description = "Human-readable summary of this deployment"
  value       = local.summary
}

output "instance_type" {
  description = "Instance type chosen based on environment (conditional expression)"
  value       = local.instance_type
}

output "upper_case_azs" {
  description = "Availability zones transformed with a for expression"
  value       = local.upper_azs
}

# sensitive variables must be marked sensitive on the output too,
# otherwise `terraform apply` will error out
output "db_password_is_set" {
  description = "Confirms the sensitive var was received, without ever printing it"
  value       = var.db_password != "" ? "provided" : "missing"
  sensitive   = true
}