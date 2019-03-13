resource "aws_vpc" "main" {
    cidr_block  =   "${var.vpc_cidr}"

    tags {
        name    =   "main-vpc"
    }
}

resource "aws_subnet" "public" {
    count       =   "${var.subnet_count}"
    vpc_id      =   "${aws_vpc.main.id}"
    cidr_block  =   "${cidrsubnet(aws_vpc.main.id, 8, count.index)}"

    tags {
        name    =   "pubsub-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    count       =   "${var.subnet_count}"
    vpc_id      =   "${aws_vpc.main.id}"
    cidr_block  =   "${cidrsubnet(aws_vpc.main.id, 8, count.index + var.subnet_count)}"

    tags {
        name    =   "privsub-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "ig" {
    vpc_id  =   "${aws_vpc.main.id}"

    tags {
        name    =   "main-ig"
    }
}

resource "aws_default_route_table" "default-route" {
    default_route_table_id  =   "${aws_vpc.main.default_route_table_id}"

    route {
        cidr_block  =   "0.0.0.0/0"
        gateway_id  =   "${aws_internet_gateway.ig.id}"
    }

    tags {
        name    =   "internet-route"
    }
}

resource "aws_route_table_association" "ig-assoc" {
    count           =   "${var.subnet_count}"
    subnet_id       =   "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id  =   "${aws_default_route_table.default-route.id}"
}