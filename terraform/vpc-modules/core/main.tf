resource "aws_vpc" "main" {
    cidr_block  =   "${var.vpc-cidr}"

    tags    {
        Name    =   "main-vpc"
    }
}

resource "aws_internet_gateway" "ig" {
    vpc_id  =   "${aws_vpc.main.id}"

    tags    {
        Name    =   "main-ig"
    }
}

resource "aws_subnet" "public" {
    vpc_id      =   "${aws_vpc.main.id}"
    count       =   "${var.subnet-count}"
    cidr_block  =   "${cidrsubnet(var.vpc-cidr, 8, count.index)}"

    tags    {
        Name    =   "pubsub-${count.index + 1}"
    }   
}

resource "aws_subnet" "private" {
    vpc_id      =   "${aws_vpc.main.id}"
    count       =   "${var.subnet-count}"
    cidr_block  =   "${cidrsubnet(var.vpc-cidr, 8, count.index + var.subnet-count)}"

    tags    {
        Name    =   "privsub-${count.index + 1}"
    }
}