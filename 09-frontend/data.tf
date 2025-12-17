## fetching private subnet ids ##
data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}

## fetching vpc id ##
data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.environment}/vpc_id"
}

## fetching backend sg id ##
data "aws_ssm_parameter" "frontend_sg_id" {
    name = "/${var.project_name}/${var.environment}/frontend_sg_id"
}

# ## fetching http listener arn ##
# data "aws_ssm_parameter" "web_alb_listener_arn_http" {
#     name = "/${var.project_name}/${var.environment}/web_alb_listener_arn_http"
# }

## fetching https listener arn ##
data "aws_ssm_parameter" "web_alb_listener_arn_https" {
    name = "/${var.project_name}/${var.environment}/web_alb_listener_arn_https"
}


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