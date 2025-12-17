## fetching ami_id ##
data "aws_ami" "ami_id" {
    most_recent = true
    owners = ["973714476881"]

    filter {
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

## fetching public subnet id ##
data "aws_ssm_parameter" "public_subnet_id" {
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

## fetching bastion sg id ##
data "aws_ssm_parameter" "bastion_sg_id" {
    name = "/${var.project_name}/${var.environment}/bastion_sg_id"
}

## fetching vpc id ##
data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.environment}/vpc_id"
}