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
        Name    =   "pubsub-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    vpc_id      =   "${aws_vpc.main.id}"
    count       =   "${var.subnet_count}"
    cidr_block  =   "${cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)}"

    tags {
        Name    =   "privsub-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "ig" {
    vpc_id      =   "${aws_vpc.main.id}"

    tags {
        Name    =   "main-ig"
    }
}

resource "aws_default_route_table" "public-rt" {
    default_route_table_id  =   "${aws_vpc.main.default_route_table_id}"

    route {
        cidr_block          =   "0.0.0.0/0"
        gateway_id          =   "${aws_internet_gateway.ig.id}"
    }

    tags {
        Name    =   "ig_route"
    }
}

resource "aws_route_table_association" "public-rt-assoc" {
    count           =   "${var.subnet_count}"
    subnet_id       =   "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id  =   "${aws_default_route_table.public-rt.id}"
}

resource "aws_eip" "nat-eip" {
    vpc     =   true

    tags {
        Name    =   "nat-eip"
    }
}

resource "aws_nat_gateway" "nat-gw" {
    subnet_id   =   "${aws_subnet.private.*.id[0]}"
    allocation_id   =   "${aws_eip.nat-eip.id}"

    tags {
        Name    =   "main-nat"
    }
}

resource "aws_route_table" "private-rt" {
    vpc_id  =   "${aws_vpc.main.id}"

    route {
        cidr_block  =   "0.0.0.0/0"
        nat_gateway_id  =   "${aws_nat_gateway.nat-gw.id}"
    }

    tags {
        Name    =   "priv-rt"
    }
}