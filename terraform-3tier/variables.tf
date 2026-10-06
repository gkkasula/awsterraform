variable "aws_region" {}
variable "environment" {}
variable "vpc_cidr" {}

# ADDED: your existing key pair name (the .ppk file is only used by PuTTY)
variable "key_name" {
  default = "21sep2026"
}

# ADDED: who can SSH into the web servers (0.0.0.0/0 = anyone, training only)
variable "ssh_cidr" {
  default = "0.0.0.0/0"
}
