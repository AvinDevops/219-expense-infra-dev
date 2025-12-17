## saving public key in aws ##
resource "aws_key_pair" "vpn" {
  key_name = "vpn"
  # public_key = "we will give public key here"
  public_key = file("~/.ssh/vpn.pub")
}


## creating vpn instance using open source module ##
module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  key_name = aws_key_pair.vpn.key_name
  name = "${var.project_name}-${var.environment}-vpn"

  instance_type = "t2.micro"
  subnet_id     = local.public_subnet_id
  ami = data.aws_ami.ami_id.id
  security_group_vpc_id = data.aws_ssm_parameter.vpc_id.value
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]

  create_security_group = false

  tags = merge (
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}