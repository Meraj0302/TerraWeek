# Task 2 — Variables, Types & Validation
# Primitives

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "instance_count" {
  description = "How many instances to provision"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "instance_count must be between 1 and 10."
  }
}

variable "enable_monitoring" {
  description = "Whether to enable monitoring/alerting"
  type        = bool
  default     = true
}

variable "db_password" {
  description = "Password for the database (never printed in plan/apply output)"
  type        = string
  default     = "changeme123!"
  sensitive   = true
}

# ---- Collections ----

variable "availability_zones" {
  description = "List of AZs to deploy into"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "common_tags" {
  description = "Common tags applied to every resource"
  type        = map(string)
  default = {
    Project = "TerraWeek"
    Owner   = "trainwithshubham"
  }
}

variable "allowed_ports" {
  description = "Unique set of ports allowed through the firewall"
  type        = set(string)
  default     = ["22", "80", "443"]
}

# ---- Structural ----

variable "app_config" {
  description = "Structured application configuration"
  type = object({
    name     = string
    replicas = number
    tags     = optional(list(string), [])
  })
  default = {
    name     = "terraweek-app"
    replicas = 3
  }
}

variable "network_settings" {
  description = "A fixed-length, fixed-type tuple: [cidr_block, subnet_count, is_public]"
  type        = tuple([string, number, bool])
  default     = ["10.0.0.0/16", 3, true]
}