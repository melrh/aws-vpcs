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

resource "aws_security_group" "ec2-sg" {
    name        = "ec2-sg"
    vpc_id      =   "${var.vpc-id}"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.ssh-ip}"]
    }

    egress  {
        from_port   =   22
        to_port     =   22
        protocol    =   "tcp"
        cidr_blocks =   ["${var.ssh-ip}"]
    }

    tags    {
        Name    =   "ec2-sg"
    }
}

resource "aws_instance" "ubuntu-ec2" {
    subnet_id       =   "${var.pubsub-ids[0]}"
    security_groups =   ["${aws_security_group.ec2-sg.id}"]

    ami             =   "${data.aws_ami.ubuntu.id}"
    instance_type   =   "t2.micro"

    tags    {
        Name    =   "ubuntu-ec2"
    }
}