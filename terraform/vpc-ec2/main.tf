provider "aws" {
    profile =   "${var.aws_profile}"
    region  =   "${var.aws_region}"
}

resource "aws_vpc" "main" {
    cidr_block  =   "${var.vpc_cidr}"

    tags    {
        Name    =   "main-vpc"
    }
}

resource "aws_subnet" "public" {
    vpc_id      =   "${aws_vpc.main.id}"
    count       =   "${var.subnet_count}"
    cidr_block  =   "${cidrsubnet(var.vpc_cidr, 8, count.index)}"

    tags    {
        Name    =   "pubsub-${count.index}"
    }
}

resource "aws_subnet" "private" {
    vpc_id      =   "${aws_vpc.main.id}"
    count       =   "${var.subnet_count}"
    cidr_block  =   "${cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)}"
}