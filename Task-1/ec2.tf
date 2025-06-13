data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical (Ubuntu) official account
}

module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "bastion"

  instance_type          = "t2.medium"
  ami                    = data.aws_ami.ubuntu.id
  key_name               = "c2020"
  associate_public_ip_address = true
  vpc_security_group_ids = [module.public_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "jenkins"

  instance_type          = "t2.medium"
  ami                    = data.aws_ami.ubuntu.id
  key_name               = "c2020"
  associate_public_ip_address = false
  vpc_security_group_ids = [module.private_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "app" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "app"

  instance_type          = "t2.medium"
  ami                    = data.aws_ami.ubuntu.id
  key_name               = "c2020"
  associate_public_ip_address = false
  vpc_security_group_ids = [module.private_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[1]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "jenkins_private_ip" {
  value = module.jenkins.private_ip
}

output "app_private_ip" {
  value = module.app.private_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}
