data "aws_ami" "ubuntu" {
    most_recent =   "true"

    filter {
        name    =   "name"
        values  =   ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
    }

    filter {
        name    =   "virtualization-type"
        values  =   ["hvm"]
    }

    owners  =   ["099720109477"]
}

resource "aws_security_group" "lb-sg" {
    name    =   "lb-sg"
    vpc_id  =   "${var.vpc_id}"

    ingress {
        from_port   =   "80"
        to_port     =   "80"
        protocol    =   "tcp"
        cidr_blocks =   ["0.0.0.0/0"]
    }
}

resource "aws_lb" "lb" {
    name            =   "lb"
    subnets         =   ["${var.pubsub_ids}"]
    security_groups =   ["${aws_security_group.lb-sg.id}"]
    internal        =   false
}

resource "aws_lb_target_group" "lb-target" {
    name        =   "lb-target"
    port        =   "80"
    protocol    =   "HTTP"
    vpc_id      =   "${var.vpc_id}"
}

resource "aws_lb_listener" "lb-listener" {
    load_balancer_arn   =   "${aws_lb.lb.arn}"
    port                =   "80"
    protocol            =   "HTTP"

    default_action  {
        target_group_arn    =   "${aws_lb_target_group.lb-target.id}"
        type                =   "forward"
    }
}

resource "aws_security_group" "ec2-sg" {
    name    =   "ec2-sg"
    vpc_id  =   "${var.vpc_id}"

    ingress {
        from_port       =   "80"
        to_port         =   "80"
        protocol        =   "tcp"
        security_groups =   ["${aws_security_group.lb-sg.id}"]
    }
}

resource "aws_launch_configuration" "ec2-launch-config" {
    name            =   "ec2-launch-config"
    image_id        =   "${data.aws_ami.ubuntu.id}"
    instance_type   =   "t2.micro"
    security_groups =   ["${aws_security_group.ec2-sg.id}"]

    lifecycle   {
        create_before_destroy   =   true
    }
}