resource "aws_launch_template" "app" {

  image_id      = var.ami
  instance_type = "t3.micro"
  key_name      = var.key_name # ADDED

  vpc_security_group_ids = [var.app_sg]
}

resource "aws_autoscaling_group" "app" {

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # ADDED: gives every app instance a Name in the EC2 console
  tag {
    key                 = "Name"
    value               = "${var.environment}-app"
    propagate_at_launch = true
  }
}
