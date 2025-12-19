## creating sg's thorugh module developmnet ##
# db sg #
module "db" {
    source = "../../217-terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_name = "db"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    description = "creating db sg"
}

# backend sg #
module "backend" {
    source = "../../217-terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_name = "backend"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    description = "creating backend sg"
}

# frontend sg #
module "frontend" {
    source = "../../217-terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_name = "frontend"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    description = "creating frontend sg"
}

# bastion sg #
module "bastion" {
    source = "../../217-terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_name = "bastion"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    description = "creating bastion sg"
}

# vpn sg #
module "vpn" {
    source = "../../217-terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_name = "vpn"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    description = "creating vpn sg"
    inbound_rules = var.vpn_sg_rules
}

# app-alb sg #
module "app_alb" {
    source = "../../217-terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_name = "app-alb"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    description = "creating app-alb sg"
}

# web-alb sg #
module "web_alb" {
    source = "../../217-terraform-aws-sg"
    project_name = var.project_name
    environment = var.environment
    sg_name = "web-alb"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    description = "creating web-alb sg"
}

## creating sg rules ##
# db #
# db accepting connection from backend
resource "aws_security_group_rule" "db_backend" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.backend.sg_id
}

# db accepting connection from bastion
resource "aws_security_group_rule" "db_bastion" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.bastion.sg_id
}

# db accepting connection from vpn
resource "aws_security_group_rule" "db_vpn" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = module.db.sg_id
    source_security_group_id = module.vpn.sg_id
}

## backend ##
# backend accepting connection from frontend
resource "aws_security_group_rule" "backend_app-alb" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.app_alb.sg_id
}

# backend accepting connection from bastion
resource "aws_security_group_rule" "backend_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.bastion.sg_id
}

# backend accepting connection from vpn_ssh
resource "aws_security_group_rule" "backend_vpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.vpn.sg_id
}

# backend accepting connection from vpn_http
resource "aws_security_group_rule" "backend_vpn_http" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    source_security_group_id = module.vpn.sg_id
}

## app-alb ##
# app-alb accepting connection from vpn
resource "aws_security_group_rule" "app_alb_vpn" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.app_alb.sg_id
    source_security_group_id = module.vpn.sg_id
}

# app-alb accepting connection from frontend
resource "aws_security_group_rule" "app_alb_frontend" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.app_alb.sg_id
    source_security_group_id = module.frontend.sg_id
}

# app-alb accepting connection from bastion
resource "aws_security_group_rule" "app_alb_bastion" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.app_alb.sg_id
    source_security_group_id = module.bastion.sg_id
}

## frontend ##
# frontend accepting connection from web-alb
resource "aws_security_group_rule" "frontend_web_alb" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.frontend.sg_id
    source_security_group_id = module.web_alb.sg_id
}

# frontend accepting connection from vpn
resource "aws_security_group_rule" "frontend_vpn" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.frontend.sg_id
    source_security_group_id = module.vpn.sg_id
}

# frontend accepting connection from bastion
resource "aws_security_group_rule" "frontend_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.frontend.sg_id
    source_security_group_id = module.bastion.sg_id
}

## web-alb ##
# web-alb accepting connection from public-http
resource "aws_security_group_rule" "web_alb_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.web_alb.sg_id
    cidr_blocks = ["0.0.0.0/0"]
}

# web-alb accepting connection from public-https
resource "aws_security_group_rule" "web_alb_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = module.web_alb.sg_id
    cidr_blocks = ["0.0.0.0/0"]
}

## bastion ##
# bastion accepting connection from public
resource "aws_security_group_rule" "bastion_public" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.bastion.sg_id
    cidr_blocks = ["0.0.0.0/0"]
}

## jenkins ##
# backend accepting connection from default_vpc
resource "aws_security_group_rule" "backend_default_vpc" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.backend.sg_id
    cidr_blocks = ["172.31.0.0/16"]
}

# frontend accepting connection from default_vpc
resource "aws_security_group_rule" "frontend_default_vpc" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.frontend.sg_id
    cidr_blocks = ["172.31.0.0/16"]
}