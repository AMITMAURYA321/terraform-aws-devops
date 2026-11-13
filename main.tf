# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  vpc_name    = "${var.project_name}-${var.environment}-vpc"
  environment = var.environment
}


# Subnet Module
module "subnet" {
  source = "./modules/subnet"

  vpc_id                = module.vpc.vpc_id
  environment           = var.environment
  subnets               = var.subnets
  public_route_table_id = module.vpc.public_route_table_id
}


# ALB Security Group
module "alb_security_group" {
  source = "./modules/security-group"

  vpc_id              = module.vpc.vpc_id
  security_group_name = var.alb_security_group_name
  environment         = var.environment

  ingress_rules = var.alb_ingress_rules
  egress_rules  = var.egress_rules
}


# EC2 Security Group
module "ec2_security_group" {
  source = "./modules/security-group"

  vpc_id              = module.vpc.vpc_id
  security_group_name = var.ec2_security_group_name
  environment         = var.environment

  ingress_rules = merge(var.ec2_ingress_rules, {
    alb_http = {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [module.alb_security_group.security_group_id]
    }
  })

  egress_rules = var.egress_rules
}


# EC2 Module
module "ec2" {
  source = "./modules/ec2"

  subnet_id         = module.subnet.subnet_ids["public_1"]
  security_group_id = module.ec2_security_group.security_group_id

  instance_type = var.instance_type
  instance_name = "${var.project_name}-${var.environment}-ec2"
  environment   = var.environment

  user_data = templatefile("${path.module}/templates/install_apache.sh", {
    project_name = var.project_name
  })
}


# ALB Module
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.alb_security_group.security_group_id

  subnet_ids = [
    module.subnet.subnet_ids["public_1"],
    module.subnet.subnet_ids["public_2"]
  ]
}
# Register EC2 Instance with ALB Target Group

resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = module.alb.target_group_arn
  target_id        = module.ec2.instance_id
  port             = 80
}