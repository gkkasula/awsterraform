# ADDED: latest Amazon Linux 2023 AMI (sir's modules use var.ami but it was never defined)
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id   = module.vpc.vpc_id
  ssh_cidr = var.ssh_cidr # ADDED
}

module "alb" {
  source = "./modules/alb"

  environment    = var.environment # ADDED (module uses it in names)
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg         = module.security_groups.alb_sg
}

module "web" {
  source = "./modules/web"

  environment  = var.environment # ADDED (used for the instance Name tag)
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnets
  web_sg       = module.security_groups.web_sg
  target_group = module.alb.target_group_arn
  ami          = data.aws_ssm_parameter.al2023.insecure_value # ADDED
  key_name     = var.key_name                                 # ADDED
}

module "app" {
  source = "./modules/app"

  environment = var.environment # ADDED (used for the instance Name tag)
  subnet_ids  = module.vpc.private_subnets
  app_sg     = module.security_groups.app_sg
  ami        = data.aws_ssm_parameter.al2023.insecure_value # ADDED
  key_name   = var.key_name                                 # ADDED
}

module "rds" {
  source = "./modules/rds"

  subnet_ids  = module.vpc.database_subnets
  rds_sg      = module.security_groups.rds_sg
  environment = var.environment # ADDED (so each environment gets its own DB name)
}
