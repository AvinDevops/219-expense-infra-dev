## creating frontend instance using open source module ##
module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-frontend"

  instance_type = "t2.micro"
  subnet_id     = local.public_subnet_id
  ami = data.aws_ami.ami_id.id
  security_group_vpc_id = data.aws_ssm_parameter.vpc_id.value
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

  create_security_group = false
  

  tags = merge (
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
    }
  )
}

## creating null resource to connect with frontend ##
resource "null_resource" "frontend" {
  # if frontend instance created, then this null resource will trigger
  triggers = {
    instance_id = module.frontend.id
  }

  # connection to frontend server
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = module.frontend.private_ip
  }

 # transferring frontend.sh from local to remote(frontend)
 provisioner "file" {
    source = "frontend.sh"
    destination = "/tmp/frontend.sh"
 }

 # connecting frontend server with remote exec
 provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/${var.common_tags.Component}.sh",
        "sudo sh /tmp/${var.common_tags.Component}.sh ${var.common_tags.Component} ${var.environment}"
    ]
 }
  
}

## stopping frontend instance ##
resource "aws_ec2_instance_state" "frontend" {
    instance_id = module.frontend.id
    state = "stopped"

# when null resource is completed then only then only it will stop
    depends_on = [null_resource.frontend]
}

## creating ami ##
resource "aws_ami_from_instance" "frontend" {
    name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
    source_instance_id = module.frontend.id

# when frontend instance is stopped then we need to create ami
    depends_on = [aws_ec2_instance_state.frontend]
}

## deleting frontend server after creating ami ##
resource "null_resource" "frontend_delete" {
  
  # if frontend instance created, then this null resource will trigger
  triggers = {
    instance_id = module.frontend.id
  }

 # connecting frontend server with local exec
 provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.frontend.id}"
 }
  
 depends_on = [aws_ami_from_instance.frontend]

}

## creating alb target group ##
resource "aws_lb_target_group" "frontend_tg" {
  name        = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path                = "/"
    port                = 80 # or a specific port like "80"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299" # Accept HTTP 2xx status codes as healthy
  }
}

## creating launch template ##
resource "aws_launch_template" "frontend_lt" {
  name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"

  image_id = aws_ami_from_instance.frontend.id

  instance_initiated_shutdown_behavior = "terminate"

  update_default_version = true

  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
        var.common_tags,
        {
            Name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
        }
    )
  }

}

## creating auto scaling group for frontend ##
resource "aws_autoscaling_group" "frontend_asg" {
  name                      = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  
  target_group_arns = [aws_lb_target_group.frontend_tg.arn]

  vpc_zone_identifier       = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

  launch_template {
    id = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling" #new servers will be created, old are deleted
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Project"
    value               = "${var.project_name}"
    propagate_at_launch = false
  }
}

## creating asg policy ##
resource "aws_autoscaling_policy" "frontend_asg_policy" {
  name                   = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 10.0
  }
}

## creating frontend list ##
resource "aws_lb_listener_rule" "frontend_lr" {
  listener_arn = data.aws_ssm_parameter.web_alb_listener_arn_https.value
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }

  condition {
    host_header {
      values = ["web-${var.environment}.${var.zone_name}"]
    }
  }
}