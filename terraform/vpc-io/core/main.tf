resource "aws_vpc" "main" {
    cidr_block  =   "${var.vpc_cidr}"

    tags {
        Name    =   "main-vpc"
    }
}

resource "aws_subnet" "public" {
    count       =   "${var.subnet_count}"
    vpc_id      =   "${aws_vpc.main.id}"
    cidr_block  =   "${cidrsubnet(var.vpc_cidr, 8, count.index)}"

    tags {
        Name    =   "pubsub-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    count       =   "${var.subnet_count}"
    vpc_id      =   "${aws_vpc.main.id}"
    cidr_block  =   "${cidrsubnet(var.vpc_cidr, 8, count.index + var.subnet_count)}"

    tags {
        Name    =   "privsub-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "ig" {
    vpc_id  =   "${aws_vpc.main.id}"

    tags {
        Name    =   "main-ig"
    }
}

resource "aws_default_route_table" "default-route" {
    default_route_table_id  =   "${aws_vpc.main.default_route_table_id}"

    route {
        cidr_block  =   "0.0.0.0/0"
        gateway_id  =   "${aws_internet_gateway.ig.id}"
    }

    tags {
        Name    =   "internet-route"
    }
}

resource "aws_route_table_association" "ig-assoc" {
    count           =   "${var.subnet_count}"
    subnet_id       =   "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id  =   "${aws_default_route_table.default-route.id}"
}

resource "aws_eip" "nat-eip" {
    vpc =   true

    tags {
        Name    =   "nat-eip"
    }
}

resource "aws_nat_gateway" "nat" {
    subnet_id       =   "${aws_subnet.private.*.id[0]}"
    allocation_id   =  "${aws_eip.nat-eip.id}"

    tags {
        Name    =   "nat-gw"
    }
}

resource "aws_route_table" "nat-route" {
    vpc_id  =   "${aws_vpc.main.id}"

    route {
        cidr_block  =   "0.0.0.0/0"
        gateway_id  =   "${aws_nat_gateway.nat.id}"
    }

    tags {
        Name    =   "nat-route"
    }
}