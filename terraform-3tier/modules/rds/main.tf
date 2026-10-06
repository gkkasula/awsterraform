resource "aws_db_subnet_group" "db" {

  name = "${var.environment}-db-subnet" # ADDED environment prefix

  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "mysql" {

  identifier = "${var.environment}-db" # sir's was "prod-db" (same name in every environment would clash)

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  username = "admin"
  password = "Password#123" # FIXED: RDS does not allow @ / " or spaces in the password

  vpc_security_group_ids = [
    var.rds_sg
  ]

  # FIXED: must be on the same line as the "=" (it was split over two lines)
  db_subnet_group_name = aws_db_subnet_group.db.name

  skip_final_snapshot = true
}
