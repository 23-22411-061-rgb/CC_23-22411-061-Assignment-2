provider "aws" {
  region = "us-east-1"
}
module "networking" {
  source            = "./modules/networking"
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  env_prefix        = var.env_prefix
}
module "security" {
  source     = "./modules/security"
  vpc_id     = module.networking.vpc_id
  env_prefix = var.env_prefix
  my_ip      = "39.49.213.121/32"
}
data "aws_ssm_parameter" "amzn2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
locals {
  ami_id = data.aws_ssm_parameter.amzn2.value
}
module "nginx_server" {
  source            = "./modules/nginx_server"
  ami_id            = local.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.nginx_sg_id
  key_name          = var.key_name
  script_path       = "./scripts/nginx-setup.sh"
}
module "backend_servers" {
  for_each = { for idx, server in var.backend_servers : server.name => server }

  source            = "./modules/backend_servers"
  ami_id            = local.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.networking.subnet_id
  security_group_id = module.security.backend_sg_id
  key_name          = var.key_name
  script_path       = each.value.script_path
}
