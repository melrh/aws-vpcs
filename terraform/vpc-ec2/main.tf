provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name    = "Main_VPC"
    Project = "Terraform_Lab"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  count      = var.subnet_count
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)

  tags = {
    Name    = "PubSub${count.index + 1}"
    Project = "Terraform_Lab"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  count      = var.subnet_count
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)

  tags = {
    Name    = "PrivSub${count.index + 1}"
    Project = "Terraform_Lab"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "Main_IG"
    Project = "Terraform_Lab"
  }
}

resource "aws_default_route_table" "public_rt" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name    = "IG_Route"
    Project = "Terraform_Lab"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = var.subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_default_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name    = "NAT_EIP"
    Project = "Terraform_Lab"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.private.*.id[0]
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name    = "Main_NAT"
    Project = "Terraform_Lab"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name    = "Priv_RT"
    Project = "Terraform_Lab"
  }
}

/*
    Gets latest Ubuntu AMI from specific owner
*/
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "ec2" {
  subnet_id = aws_subnet.public.*.id[0]

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name    = "Ubuntu_EC2"
    Project = "Terraform_Lab"
  }
}