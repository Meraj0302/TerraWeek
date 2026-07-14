output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "web_instance_public_ip" {
  value = aws_eip.web.public_ip
}

output "web_instance_id" {
  value = aws_instance.web.id
}

output "worker_instance_ids" {
  value = aws_instance.worker[*].id
}

output "app_instance_ids" {
  value = { for k, v in aws_instance.app : k => v.id }
}

output "ami_used" {
  value = data.aws_ami.al2023.id
}
