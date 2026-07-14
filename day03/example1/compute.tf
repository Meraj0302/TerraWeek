
resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  # explicit ordering: make sure the route to the internet exists
  # before we boot an instance that needs to reach it (e.g. for yum update)
  depends_on = [aws_route_table_association.public]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    echo "<h1> Hello from TerraWeek 2026, Keep it up Meraj Boom! </h1>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOF
# Task 4: count — N identical, interchangeable instances

  tags = {
    Name        = "terraweek-web"
    LastModified = timestamp()
  }

  lifecycle {
    create_before_destroy = true
    # a real prod instance would often add: prevent_destroy = true
    ignore_changes = [tags["LastModified"]]
  }
}

# Task 4: count — N identical, interchangeable instances


resource "aws_instance" "worker" {
  count = var.worker_count

  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "terraweek-worker-${count.index}"
  }
}


# Task 4: for_each — named instances from a map
# (preferred over count when each instance has a stable identity;
#  removing "api" from the map won't reindex/replace "web")


resource "aws_instance" "app" {
  for_each = var.extra_instances

  ami                    = data.aws_ami.al2023.id
  instance_type          = each.value.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "terraweek-${each.key}"
  }
}


# Bonus: Elastic IP attached to the primary instance


resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "terraweek-web-eip"
  }
}
