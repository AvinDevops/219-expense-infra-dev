## fetching ami_id ##
data "aws_ami" "ami_id" {
    most_recent = true
    owners = ["679593333241"]

    filter {
        name = "name"
        values = ["OpenVPN Access Server Community Image-fe8020db-*"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    # filter {
    #     name = "creation-date"
    #     values = ["2024-03-07T15:11:08.000Z"]
    # }
}

## fetching public subnet id ##
data "aws_ssm_parameter" "public_subnet_id" {
    name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

## fetching bastion sg id ##
data "aws_ssm_parameter" "vpn_sg_id" {
    name = "/${var.project_name}/${var.environment}/vpn_sg_id"
}

## fetching vpc id ##
data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.environment}/vpc_id"
}