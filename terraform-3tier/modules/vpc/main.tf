resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true # ADDED
  enable_dns_hostnames = true # ADDED

  tags = {
    Name = "${var.environment}-vpc"
  }
}

# ADDED: internet gateway (public subnets need it to reach the internet)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Public Subnets
# (cidrsubnet gives the same 10.0.1.0/24, 10.0.2.0/24 ... as sir's, but follows vpc_cidr)
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = { Name = "${var.environment}-public1" }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true # ADDED

  tags = { Name = "${var.environment}-public2" }
}

# Private Subnets
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 11)
  availability_zone = "ap-south-1a" # ADDED

  tags = { Name = "${var.environment}-private1" }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 12)
  availability_zone = "ap-south-1b" # ADDED

  tags = { Name = "${var.environment}-private2" }
}

# Database Subnets
resource "aws_subnet" "db1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 21)
  availability_zone = "ap-south-1a" # ADDED

  tags = { Name = "${var.environment}-db1" }
}

resource "aws_subnet" "db2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 22)
  availability_zone = "ap-south-1b" # ADDED

  tags = { Name = "${var.environment}-db2" }
}

# ADDED: public route table (0.0.0.0/0 -> internet gateway) for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "${var.environment}-public-rt" }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
