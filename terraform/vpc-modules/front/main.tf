data "aws_ami" "ubuntu" {
    most_recent =   true

    filter  {
        name    =   "name"
        values   =   ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
    }

    filter  {
        name    =   "virtualization-type"
        values   =   ["hvm"]
    }

    owners  =   ["099720109477"]
}

resource "aws_security_group" "ec2_sg" {
    name        = "ec2_sg"
    vpc_id      =   var.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.ssh_ip]
    }

    egress  {
        from_port   =   22
        to_port     =   22
        protocol    =   "tcp"
        cidr_blocks =   [var.ssh_ip]
    }

    tags = {
        Name    =   "terraform_lab"
    }
}

resource "aws_instance" "ubuntu_ec2" {
    subnet_id       =   var.pubsub_ids[0]
    security_groups =   [aws_security_group.ec2_sg.id]

    ami             =   data.aws_ami.ubuntu.id
    instance_type   =   "t2.micro"

    tags = {
        Name    =   "terraform_lab"
    }
}