output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]
}

output "database_subnets" {
  value = [
    aws_subnet.db1.id,
    aws_subnet.db2.id
  ]
}
