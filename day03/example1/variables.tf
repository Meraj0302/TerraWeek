variable "aws_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Secondary/DR AWS region (used by the aliased provider)"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro" # free-tier friendly
}

# --- used by Task 4 for_each demo ---
variable "extra_instances" {
  description = "Map of named EC2 instances to create with for_each"
  type = map(object({
    instance_type = string
  }))
  default = {
    web = { instance_type = "t3.micro" }
    api = { instance_type = "t3.micro" }
  }
}

# --- used by Task 4 count demo ---
variable "worker_count" {
  description = "Number of identical worker instances to create with count"
  type        = number
  default     = 2
}
