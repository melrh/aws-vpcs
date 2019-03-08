provider aws {
    profile =   "${var.aws_profile}"
    region  =   "${var.aws_region}"
}

resource "aws_vpc" "main" {
    cidr_block  =   "${var.vpc_cidr}"

    tags {
        Name    =   "Main"
    }
}

resource "aws_subnet" "public" {
    count       =   "${var.subnet_count}"
    vpc_id      =   "${aws_vpc.main.id}"
    cidr_block  =   "${cidrsubnet(var.vpc_cidr, 8, count.index)}"

    tags {
        Name    =   "pubsub"
    }
}

resource "aws_subnet" "private" {
    count       =   "${var.subnet_count}"
    vpc_id      =   "${aws_vpc.main.id}"
    cidr_block  =   "${cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)}"

    tags {
        Name    =   "privsub"
    }
}