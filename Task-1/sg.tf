module "public_sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "public-sg"
  description = "Security group for public instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "ssh-service ports"
    }
  ]

  egress_rules = ["all-all"]
}

module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "private-sg"
  description = "Security group for private instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
      description = "Allow all TCP traffic"
    }
  ]

  egress_rules = ["all-all"]
}
