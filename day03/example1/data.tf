############################################
# Task 2: Data Sources (read-only lookups)
############################################

# Latest Amazon Linux 2023 AMI — we don't manage this AMI, we just read it
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Availability zones available to this account/region
data "aws_availability_zones" "available" {
  state = "available"
}

/*
RESOURCES vs DATA SOURCES
---------------------------
- `resource` blocks tell Terraform to CREATE and manage the full lifecycle
  of something (create, update in-place or replace, and destroy it). If you
  delete a resource block and apply, Terraform deletes the real object.

- `data` blocks only READ information that already exists (either created
  outside Terraform, like an account's default VPC, or created elsewhere in
  the same config). Terraform never creates/modifies/destroys the thing a
  data source points to — it just fetches attributes you can reference,
  e.g. data.aws_ami.al2023.id below in compute.tf.
*/
