resource "aws_lb" "alb" {

  name = "${var.environment}-alb"

  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_sg]
  subnets         = var.public_subnets
}

# Target Group
resource "aws_lb_target_group" "web" {

  name     = "${var.environment}-web-tg" # ADDED environment prefix (names must be unique per region)
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Listener
resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.web.arn
  }
}
