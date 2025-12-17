## creating bastion instance using open source module ##
module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-bastion"

  instance_type = "t2.micro"
  subnet_id     = local.public_subnet_id
  ami = data.aws_ami.ami_id.id
  security_group_vpc_id = data.aws_ssm_parameter.vpc_id.value
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]

  create_security_group = false
  user_data = file("bastion.sh")

  tags = merge (
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}