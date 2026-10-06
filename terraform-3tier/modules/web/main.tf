resource "aws_launch_template" "web" {

  name_prefix = "web"

  image_id      = var.ami
  instance_type = "t3.micro"
  key_name      = var.key_name # ADDED

  vpc_security_group_ids = [var.web_sg]

  # ADDED: installs nginx so the load balancer health check passes
  user_data = base64encode(<<-EOT
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>Web server - $(hostname)</h1>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT
  )
}

resource "aws_autoscaling_group" "web" {

  desired_capacity = 2
  max_size         = 4
  min_size         = 2

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [
    var.target_group
  ]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  # ADDED: gives every web instance a Name in the EC2 console
  tag {
    key                 = "Name"
    value               = "${var.environment}-web"
    propagate_at_launch = true
  }
}
