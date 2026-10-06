output "alb_sg" {
  value = aws_security_group.alb.id
}

output "web_sg" {
  value = aws_security_group.web.id
}

output "app_sg" {
  value = aws_security_group.app.id
}

output "rds_sg" {
  value = aws_security_group.rds.id
}
