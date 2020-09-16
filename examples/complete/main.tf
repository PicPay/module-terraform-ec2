data "aws_vpc" "default" {
  tags = {
    Name = "VPC Default"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "Private Subnet - us-east-1e"
  }
}

data "aws_ami" "picpay-amazon-linux-2" {
  most_recent = true
  owners = ["869825878781"]

  tags = {
    Name   = "picpay-amzn2-ami-hvm-*"
  }
}

module "keypair-ssm" {
  source   = "../ops-terraform-keypair-ssm"
  key_name = "testeec2"
}

module "instance" {
  source            = "../module-terraform-ec2"
  ssh_key_pair      = module.keypair-ssm.key_name
  vpc_id            = data.aws_vpc.default.id
  for_each          = data.aws_subnet_ids.private.ids
  subnet            = each.value
  application       = "docker"
  environment       = "lab"
  name              = "ec2_teste"
  squad             = "InfraCore"
  costcenter        = "1462"
  tribe             = "Infra Cloud"
}